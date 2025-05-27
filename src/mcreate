%% Mcreate
% A script to finish the import by making a script, in the results folder,
% that includes a guide to variable names, and some code to replot things.
% CMM 2020

idx = strfind(filename,'.'); 
scriptname=filename(1:idx-1);
scriptname = sprintf('%splotter.m', scriptname);
fid = fopen(fullfile(resultsdir, scriptname), 'wt'); %and use 't' with text files so eol are properly translate

fprintf(fid, '%%A file-specific plotter script to understand variables and replot\n');
fprintf(fid, '%%Written by CM Magazzeni 2020\n');
fprintf(fid, '\n');

fprintf(fid, '%%Guide to variable names: \n');
fprintf(fid, '%%X, Y = X and Y positions, in units of micron \n');
fprintf(fid, '%%S    = Surface displacement, or the position of the tip at contact, nm\n');
fprintf(fid, '%%D    = Indent depth, nm\n');
fprintf(fid, '%%L    = Load, mN \n');
fprintf(fid, '%%M    = Modulus, GPa \n');
fprintf(fid, '%%S2oL = Stiffness Squared over Load, N/m \n');
fprintf(fid, '%%H    = Hardness, GPa \n');
fprintf(fid, '%%HnM  = Hardness over modulus, unitless \n');
fprintf(fid, '%%logH = log of Hardness, unitless \n');
fprintf(fid, '\n');

fprintf(fid, '%%fullres    = The block of data from S to H\n');
fprintf(fid, '%%fullresloc = The block of data containing X and Y\n');
fprintf(fid, '\n');

fprintf(fid, '%%meanH, meanM = mean of Hardness and Modulus\n');
fprintf(fid, '%%stdH, stdM   = standard deviation of Hardness and Modulus\n');
fprintf(fid, '%%ceilingH     = maximum allowed Hardness \n');
fprintf(fid, '%%ceilingM     = maximum allowed Modulus \n');
fprintf(fid, '%%cleanplotq   = a boolean to choose whether to clean the plot or not\n');
fprintf(fid, '\n');

fprintf(fid, '%% Below are two blocks of code plotting Hardness and Modulus\n');
fprintf(fid, '%% You can change them as you see fit, or mathematically manipulate\n');
fprintf(fid, '%% any of the variables to do what you like.\n');
fprintf(fid, '\n');

fprintf(fid, '%%HARDNESS PLOT SCRIPT\n');
fprintf(fid, 'figure;%%create a figure\n');
fprintf(fid, "hplot=contourf(X,Y,H,455,'LineColor','None'); %%plot X, Y, and Hardness as a contour plot\n");
fprintf(fid, '%%this makes a nice figure with interpolation in the visualisation, \n');
fprintf(fid, '%%but no interpolation in the data itself. 455 levels for smooth colours, \n');
fprintf(fid, '%%and no contour lines. \n');
if meanH>stdH
    fprintf(fid, 'caxis([meanH-0.5*stdH meanH+0.5*stdH]) %%colourbar with 1 standard deviation width\n');
else 
    fprintf(fid, 'caxis([min(hplot(:)) meanH+1*stdH]) %% colourbar with 1 stdev width starting from 0\n');
end
fprintf(fid, "title('Hardness')\n");
fprintf(fid, "xlabel('\\mum')\n");
fprintf(fid, "ylabel('\\mum')\n");
fprintf(fid, 'axis image %%make it square\n');
fprintf(fid, 'c=colorbar; %%add a colourbar\n');
fprintf(fid, "c.Label.String = 'Hardness (GPa)';\n");
fprintf(fid, "figname=['Hardness Figure ' filename(1:(max(size(filename)-4)))]; %%variable name\n");
fprintf(fid, "print(fullfile(resultsdir, figname),'-dpng') %%and save it\n");
fprintf(fid, '\n');

fprintf(fid, '%%MODULUS PLOT SCRIPT\n');
fprintf(fid, 'figure; %%this is the same format as hardness, but with M, modulus\n');
fprintf(fid, "hplot=contourf(X,Y,M,455,'LineColor','None');\n");
fprintf(fid, "title('Modulus')\n");
fprintf(fid, "xlabel('\\mum')\n");
fprintf(fid, "ylabel('\\mum')\n");
fprintf(fid, 'axis image\n');
if meanM>stdM
    fprintf(fid, 'caxis([meanM-0.5*stdM meanM+0.5*stdM]) %%colourbar with 1 standard deviation width\n');
else 
    fprintf(fid, 'caxis([min(hplot(:)) meanM+1*stdM]) %% colourbar with 1 stdev width starting from 0\n');
end
fprintf(fid, 'c=colorbar;\n');
fprintf(fid, "c.Label.String = 'Modulus (GPa)';\n");
fprintf(fid, "figname=['Modulus Figure ' filename(1:(max(size(filename)-4)))];\n");
fprintf(fid, "print(fullfile(resultsdir, figname),'-dpng')\n");

fprintf(fid, '%% You could, for instance, plot Hardness times modulus by doing: \n');
fprintf(fid, 'HtimesM=H.*M; \n');
fprintf(fid, '%% The new variable HtimesM can then be plotted by copying the above snippets\n');
fprintf(fid, '%% and replacing M in the contourf line with HtimesM\n');
% Close the file.
fclose(fid);
% Open the file in the editor.
edit(fullfile(resultsdir,scriptname));
clear fid idx hist hplot isdel figname scriptname txt c
