% This was the script used to anatomically label the coordinates using
% Anatomy Toolbox.
% ------------------------------------
% AX 04/01/2019

% First, specify the parameters needed to label the coordinates
%   Anatomy map (.mat file located in dependencies/Anatomy
anatomyMap='dependencies/Anatomy/Anatomy_v22c_MPM.mat';
%   Coordinate text file (this was outputted from
%   ExtractClusters/clusterTexts/resultsExtract.Rmd)
coords='ExtractClusters/clusterTexts/painHealthyResultsCoords_20190401.txt';
%   Output name for the anatomical text file (which is a text file that
%   will also give you the probabilities for each label)
outputText='ExtractClusters/clusterTexts/painHealthyResultsAnat_20190401.txt';
%   And the .csv file that will give you the macroanatomical and
%   cytoarchitectonic label -- put these outputs in the same folder as
%   clusterTexts
outputCSV='ExtractClusters/clusterTexts/painHealthyResultsAnat_20190401.csv';

% The actual command: label all contrasts (04/02/2019)
anatomy_label(anatomyMap, coords, 2, outputText, outputCSV);

