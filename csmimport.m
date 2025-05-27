%Written by C.M. Magazzeni to import Express nanoindentation data from the
%KLA Tencor G200 nanoindenter.
% CMM 2020, modified by S Ter 2025

[fullres, fullresloc]=load_gridCSM(filepath, filename, batchinfo, batchdims,displacementrange,tangent); %Loading all the data from the sheet.
plot_fig; %plotting results
mcreate;  %create a script for handy plotting in the results folder
%% Save all workspace to .mat file in the results folder
save([fullfile(resultsdir,[filename(1:length(filename)-5) '_CSM_results']) '.mat']);


disp 'CSM Import Complete'
