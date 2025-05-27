function [fullres, fullresloc] = load_gridCSM(filepath, filename, batchinfo, batchdims,displacementrange,tangent) 
tempfp=fullfile(filepath, filename);

% Parameters
batchdim_x = batchdims(1); % X batch dimension (in µm)
batchdim_y = batchdims(2); % Y batch dimension (in µm)
num_x = batchinfo(1); % Number of indents in X-direction
num_y = batchinfo(2); % Number of indents in Y-direction
min_Displacement = displacementrange(1); % Displacement range (nm)
max_Displacement = displacementrange(2);
x0=1/tangent;

% Initialize fullres and fullresloc % [rows, cols, layers for X and Y]
fullres = NaN(num_y, num_x, 4); % Store hardness, modulus, H0, hstar
fullresloc = NaN(num_y, num_x, 2); % Store X and Y coordinates

% Iterate through tests

% Loop through rows and columns
for y = 1:num_y
    for x = 1:num_x
        % Calculate X coordinate
        if mod(y, 2) == 1
            sheettemp1 = batchinfo(1)*(y-1)+x;
            % Odd rows: left-to-right
        else
            % Even rows: right-to-left
            sheettemp1=batchinfo(1)*(y-1)+(batchinfo(1)-(x-1)); %if it's an even line
        end

        % Calculate Y coordinate
        coord_y = (y - 1) * batchdim_y;
        coord_x = (x-1)*batchdim_x;

        % Store coordinates
        fullresloc(y, x, 1) = coord_x; % X coordinate
        fullresloc(y, x, 2) = coord_y; % Y coordinate

        if sheettemp1<10 %SORT OUT ZEROS: sheet names aren't computer friendly
            sheettemp=strcat('00',num2str(sheettemp1));
        elseif sheettemp1<100
            sheettemp=strcat('0',num2str(sheettemp1));
        elseif sheettemp1>=100
            sheettemp=num2str(sheettemp1);
        end
        sheetpull=['Test' ' ' sheettemp];%pull out the right sheet
        %check if the sheet exists, otherwise, remove the word "Tagged"

        % Display which sheet is being processed
        disp(['Processing sheet: ', sheetpull]);

        % Handle non-computer-friendly sheet names
        try
            % Attempt to read the sheet from the single Excel file
            data = readmatrix(tempfp, 'Sheet', sheetpull);
        catch
            % Adjust for alternative naming conventions (e.g., remove spaces)
            sheetpull = strrep(sheettemp, ' ', '');
            data = readmatrix(tempfp, 'Sheet', sheetpull);
        end


        % Extract relevant columns
        displacement = data(:, 2); % Displacement into surface
        hardness = data(:, 6); % Hardness
        modulus = data(:, 7); % Modulus

        % Filter data within displacement range
        in_range = displacement >= min_Displacement & displacement <= max_Displacement & hardness <= 10 ; %finds index within the range
        avg_hardness = mean(hardness(in_range));
        avg_modulus = mean(modulus(in_range));
        displacement=displacement(in_range);
        hardness = hardness(in_range);
        modulus=modulus(in_range);


                % BINNING
        num_bins = 50;  % Ensure at least 1 bin is created

        bin_edges = linspace(min(displacement), max(displacement), num_bins + 1);  % Creates 25 bins, with 26 edges

        % Assign each displacement into a bin
        [~, ~, bin_idx] = histcounts(displacement, bin_edges);
        
        % Initialize binned arrays
        binned_disp = NaN(num_bins, 1); % Average displacement per bin
        binned_hardness = NaN(num_bins, 1); % Average hardness per bin
        binned_modulus = NaN(num_bins, 1); % Average modulus per bin
        
        for b = 1:num_bins
            bin_mask = bin_idx == b;
            if any(bin_mask)
                binned_disp(b) = mean(displacement(bin_mask)); % Mean displacement in bin
                binned_hardness(b) = mean(hardness(bin_mask)); % Mean hardness in bin
                binned_modulus(b) = mean(modulus(bin_mask)); % Mean modulus in bin
            end
        end
        
        % Remove NaN bins
        valid_bins = ~isnan(binned_disp) & ~isnan(binned_hardness);


        % Calculate values to plot
        X = 1 ./ binned_disp(valid_bins); % 1/h values
        Y = binned_hardness(valid_bins) .^ 2; % H^2 values
        % Polynomial fit
        polyCoeffs = polyfit(X, Y, 2); % Fit polynomial of chosen degree
        x_fit = linspace(min(X), max(X), 100); % Smooth range for plotting curve
        y_fit = polyval(polyCoeffs, x_fit); % Compute fitted curve

        % Plot polynomial fit
        plot(x_fit, y_fit, 'r-', 'LineWidth', 2); % Plot fitted curve in red

        % Compute derivative (tangent slope)
        polyDeriv = polyder(polyCoeffs); % Get derivative coefficients
        m_tangent = polyval(polyDeriv, x0); % Evaluate slope at x0
        y0_tangent = polyval(polyCoeffs, x0); % Evaluate y at x0

        % Compute y-intercept of the tangent line
        b_tangent = y0_tangent - m_tangent * x0;

        % Plot tangent line at x0
        x_tangent = linspace(x0 - 0.0005, x0 + 0.0005, 10); % Small range around x0
        y_tangent = m_tangent * x_tangent + b_tangent; % Compute tangent equation
        plot(x_tangent, y_tangent, 'g--', 'LineWidth', 2); % Green dashed tangent

        % Compute H_o and h_star
        if b_tangent > 0 % Ensure positive y-intercept
            H_o = sqrt(b_tangent); % H_o = sqrt(y-intercept)
            h_star = m_tangent / (H_o^2); % h_star = gradient / H_o^2
        else
            H_o = 0; % Invalid case
            h_star = 0;
        end

        % Store averaged values in fullres
        fullres(y, x, :) = [avg_hardness, avg_modulus, H_o, h_star];

    end
end

% Output results
disp('Full Results (Averaged Hardness and Modulus):');
disp(fullres);
disp('Full Results Location (X, Y Coordinates):');
disp(fullresloc);
