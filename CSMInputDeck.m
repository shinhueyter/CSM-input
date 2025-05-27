%% This is the input deck, and the only file which should need editing
% Here you will input the filepath, filename, and various details of the
% CSM data

clear all
close all
addpath src

%% Input variables 
% CM Magazzeni 2020, modified by S Ter for CSM inputs

% The file to be imported. Must be xlsx and '  ' 
filename='30x10_6um_300nm_Cu_on_Ni.xlsx'; %filename must be xlsx if not need to change resultsdir in plot_fig -4 instead of -5
filepath='C:\Users\corp3216\OneDrive - Nexus365\Part II\nanoindentation\2025-03-17 Batch #00002 new\'; %file location (with final \)
% results will be saved here under express_results

batchinfo=[10, 30];%Batch size: [# of indents in x, # of indents in y] 
batchdims=[+6, +6];%Batch dimensions: indent spacing in microns
displacementrange = [100,300]; %for average hardness & ISE plot
tangent = 300; %displacement at which Nix-Gao equation is fitted to extract H0 and h*

polyDegree = 2; %coefficients for ISE curve fit

%DISCLAIMER: this is a hack, and is not supposed to be used prior to any
%statistical analysis. This is purely for visualisation purposes. 
cleanplotq = 1; %clean up NaN values?
resolution = ['-r' num2str(600)];

%% Then just click run on this section
csmimport;
