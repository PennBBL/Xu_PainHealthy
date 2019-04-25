#!/bin/bash

# Extracts the statistics of the main effects and conjunction maps
# -----------------------------
# uses FSL and assumes the exact file structure outputted by the MATLAB script "painHealthyAnalysis.m"
# nb: keep this script in the main directory
#
# Inputs: 
#   1) ALE outputs in the folder "EickhoffALE/ALE/Results" (for main effects maps);
#   2) ALE outputs in the folder "Eickhoff/ALE/Conjunctions" (for conjunction maps)
#
# Outputs:
#   1) Folder "ExtractClusters/clusterNifti" for nifti results from FSL
#       -- NB.1: these are the same as ALE outputs because the threshold is the same
#       -- NB.2: "mainEffects" subfolder will contain the text files for main effects; "conjunctions" for conjunctions
#       -- NB.3: the niftis will be named by the effect of interest (e.g., "fullThresh_thermal_cFWE05.nii")
#   2) Folder "ExtractClusters/clusterTexts" for text files of cluster statistics from FSL
#       -- NB.1: "mainEffects" subfolder will contain the text files for main effects; "conjunctions" for conjunctions
#       -- NB.2: the text files will be named by the effect of interest (e.g., "thermal.txt" for main effect of thermal)
# ------------------------------
# Written by AX -- 04/01/2019

######################################################
# Setup 
#   Organize directory structure
#   Specify main effects and conjunction folders
######################################################

# Create the directory structure for main effects
cd ExtractClusters/clusterNifti
mkdir mainEffects
cd ../..
cd ExtractClusters/clusterTexts
mkdir mainEffects
cd ../..

# Create the directory structure for conjunctions
cd ExtractClusters/clusterNifti
mkdir conjunctions
cd ../..
cd ExtractClusters/clusterTexts
mkdir conjunctions
cd ../..

# Specify the folder for main effects and conjunction
niftiMainEffect="EickhoffALE/ALE/Results/*_cFWE05.nii"
niftiConjunction="EickhoffALE/ALE/Conjunctions/*_cFWE05.nii"

######################################################
# Main Effects
######################################################

for main in $niftiMainEffect; do
#   Extract the name of the main effects (e.g., "thermal" from the file "thermal_cFWE05.nii")
    mainEffectName=$(echo $main|cut -d '/' -f4|cut -d '_' -f1);
#   Extract the cluster statistics, thresholded voxelwise at z > 3.09
#   Outputs: nifti with thresholded image; text file with the statistics
#       - the thresholded image will essentially be the same as the ALE output in "EickhoffALE/ALE/Results/*_cFWE05.nii"
#       ----this is because the ALE outputted map was already thresholded at z > 3.09    
    cluster -i ${main} --zthresh=3.09  --othresh=fullThresh_${mainEffectName} --mm > ${mainEffectName}.txt
#   Organize the directory structure
#       Move the text files with the statistics into "clusterTexts"
    mv ${mainEffectName}.txt ExtractClusters/clusterTexts/mainEffects
#       Move the thresholded niftis into "clusterNifti"
    mv fullThresh_${mainEffectName}.nii.gz ExtractClusters/clusterNifti/mainEffects
done  

######################################################
# Conjunctions
######################################################

for conj in $niftiConjunction; do
#   Extract the name of the conjunction (e.g., "electrical_AND_mechanical" from the file "electrical_AND_mechanical.nii")
    conjunction=$(echo $conj|cut -d '/' -f4|cut -d '.' -f1);
#   Outputs: nifti with thresholded image; text file with the statistics
#       - the thresholded image will essentially be the same as the ALE output in "EickhoffALE/ALE/Results/*_cFWE05.nii"
#       ----this is because the ALE outputted map was already thresholded at z > 3.09
    cluster -i ${conj} --zthresh=3.09  --othresh=fullThresh_${conjunction} --minextent=25 --mm > ${conjunction}.txt
#   Organize the directory structure
#       Move the text files with the statistics into "clusterTexts"
    mv ${conjunction}.txt ExtractClusters/clusterTexts/conjunctions
#       Move the thresholded niftis into "clusterNifti"
    mv fullThresh_${conjunction}.nii.gz ExtractClusters/clusterNifti/conjunctions
done
