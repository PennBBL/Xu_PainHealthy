% Generate the brain figures after thresholded
% --------------------------
% In each section, the following steps are taken:
%
%   1. Go to the appropriate folder where certain results are (e.g., main
%   effects located in "Eickhoff/ALE/Results")
%   
%   2. Create a Figures folder where all the figures will be ultimately
%   located for that type of analyses.
%   
%   3. Generate all the figures in a specific path (e.g., if interested in
%   cFWE-corrected images, use "*_cFWE05.nii")
%
%   4. Output figures using the function brainFiguresFromPath().
%       "dependencies/wrappers/brainFiguresFromPath.m" gives full
%       documentation of this script but briefly,
%           -- this function needs :
%               (A) specification of type of analyses as a string 
%                   (e.g., 'main', 'contrast', 'conjunction'); 
%               (B) number of expected figures to be outputted
%               (C) string path of figures to be generated from (i.e., the niftis)
%           -- outputs *.jpg files with the same name as the niftis
%
%   5. Move appropriate figures to the Figures folder.
% --------------------------
% Written by AX 04/26/2019

%% Set parameters
% Specify the number of effects expected to generate figures for:
numME=16; % number of main effects
numConj=6; % number of conjunctions
% note: contrast is tricky for reasons stated in the between-groups study
% contrast section

%% Generate figures 

% 1. Main effects
%   Go to the appropriate folder and create Figures directory
cd EickhoffALE/ALE/Results;
mkdir Figures
%   Specify the path of interest 
mainEffectsPath='*_cFWE05.nii';
%   Use function brainFiguresFromPath() function 
brainFiguresFromPath('main',numME, mainEffectsPath);
%   Move to appropriate folder
movefile *.jpg Figures;
cd ../../..;

% 2. Conjunctions (same process as Main Effects)
cd EickhoffALE/ALE/Conjunctions;
mkdir Figures
conjunctionsPath='*_cFWE05.nii';
brainFiguresFromPath('conjunction',numConj, conjunctionsPath);
%   Move to appropriate folder
movefile *.jpg Figures;
cd ../../..;

% 3. Contrasts (for z > 3.09, k > 25)
%
%   NB: between-study contrasts are tricky because the brain figure
%   generator function relies on calculating the brain volume range (so
%   null results will result in an error message) --> THEREFORE, ONLY DO
%   THIS FOR THE SIGNIFICANT RESULTS
%
%   For figures in this section, use the function gen_figure() instead of
%   brainFiguresFromPath(); this function generates a figure for a specific
%   nifti (by taking in the inputs: (A) string of name of effect; (B)
%   string of nifti name; (c) name of the .jpg file as a string
%
% Prior to generating figures, make sure to unzip .nii.gz files
% so that figures are generated from .nii files

gunzip('ExtractClusters/clusterNifti/fullThreshContrasts/*.gz');
           
%   Go to the appropriate file path and create the Figures folder
cd ExtractClusters/clusterNifti/fullThreshContrasts;
mkdir Figures
%   Create jpegs for specific niftis that were significant
gen_figure('contrast', 'fullThresh_left--right.nii', 'leftRightContrast.jpg')
gen_figure('contrast', 'fullThresh_thermal--otherMod.nii', 'thermalOtherContrast.jpg')
gen_figure('contrast', 'fullThresh_electrical--mechanical.nii', 'electricalMechanicalContrast.jpg')
%   Move to appropriate folder
movefile *.jpg Figures;
cd ../../..;
