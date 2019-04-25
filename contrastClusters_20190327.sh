#!/bin/bash

# Extracts the statistics of the between-study contrast maps
# -----------------------------
# uses FSL and assumes the exact file structure outputted by the MATLAB script "painHealthyAnalysis.m"
# --also rethresholds the results at z > 3.09 (rather than keeping them at z > 1.6)
# nb: keep this script in the main directory
#
# Inputs: 
#   1) ALE outputs in the folder "EickhoffALE/ALE/Contrasts" 
#
# Outputs:
#   1) Folder "ExtractClusters/clusterNifti" for nifti results from FSL
#       A) Subfolder "fullThreshContrasts" for niftis with the positive and negative values (z > 3.09)
#       B) Subfolder "threshContrasts" for niftis that separate negative and positive values
#           --e.g., "posThresh_visceral--notVisceral.nii.gz" for visceral > not visceral contrast
#       C) Subfolders "liberalThreshNeg" and "liberalThreshPos" for same versions except at z > 1.6 instead of z > 3.09
#                   "negThresh_visceral--notVisceral.nii.gz" for not visceral > visceral contrast
#       D) Subfolder "unthresh" (ONLY NECESSARY FOR ANALYSES) for niftis where negative contrasts become positively valued
#           --NB: more details in the script below
#   2) Folder "ExtractClusters/clusterTexts" for text files of cluster statistics from FSL
#       A) Subfolder "thresh" contains the statistics for clusters thresholded at z > 3.09, k > 25 
#       -- NB: negThresh_*.txt refers to negative contrasts while posThresh_*.txt refers to positive contrasts
# ------------------------------
# Written by AX -- 04/01/2019

######################################################
# Setup 
#   Organize directory structure
#   Specify contrast folder
######################################################

# Initialize with clean directory structure
#   Nifti folder
cd ExtractClusters/clusterNifti
mkdir unthresh # liberally thresholded niftis (z > 1.6) BUT ONLY FOR NEGATIVE CONTRASTS (neg contrasts become positive)
mkdir threshContrasts # thresholded niftis at a more conservative threshold (z > 3.09) -- separates positive & negative contrasts
mkdir fullThreshContrasts # thresholded nfitis (z > 3.09) -- combines positive & negative contrasts into one image
cd ../..
#   Text of statistics folder
cd ExtractClusters/clusterTexts 
mkdir thresh # just include one folder for all thresholded images (will indicate neg/pos contrast by title)
cd ../..

# Specify the contrast folder
niftiContrast="EickhoffALE/ALE/Contrasts/*_P95.nii"

######################################################
# Contrasts
######################################################

# 1. MANIPULATE THE ORIG. CONTRAST NIFTIS TO GET THE NEGATIVE VALUES THRESHOLDED
# Get the z>1.6 version of the negative contrast (in the ALE output) to be positive
#   This is because FSL thresholds with positive values
# 1A. AT THE SAME TIME, GET THE THRESHOLDED VALUES FOR POSITIVE CONTRAST
for n in $niftiContrast; do
#   Get contrast name (e.g., "left--right")
contrastName=$(echo $n|cut -d '/' -f4|cut -d '_' -f1);
# negative contrast turns positive (through multiplying by -1)
#   rename the nifti where the negative values turned positive as "negative_#"
fslmaths $n -mul -1 negative_${contrastName} 
# before working with the negative contrast, threshold the positive contrast at z > 3.09, k > 25
#   output posThresh_*.txt for positive contrast thresholded results
cluster -i ${n} --zthresh=3.09 --othresh=posThresh_${contrastName} --minextent=25 --mm > posThresh_${contrastName}.txt
# move the negative contrast (turned positive) nifti to appropriate folder (NOTE: we did not threshold negative yet)
mv negative_${contrastName}.nii.gz ExtractClusters/clusterNifti/unthresh
done
 
# 2. THRESHOLD AND GET STATISTICS FOR NEGATIVE CONTRAST
#   Specify the negative contrast niftis (i.e., output from fslmaths when multiplying ALE output by -1)
negNiftis="ExtractClusters/clusterNifti/unthresh/negative_*.nii.gz"
for negcon in $negNiftis; do
#   defines the naming of files (e.g., "left--right")
negcontrast=$(echo $negcon|cut -d '/' -f4|cut -d '.' -f1|cut -d '_' -f2);
#   Threshold the negative clusters to z>1.6 to z>3.9 instead
#       Output new nifti of the negative clusters thresholded AND text file of the statistics at this new threshold
#       Names niftis and texts as negThresh_* 
#       NB: AT THIS STAGE, NOTHING IS MOVED YET--directories from here get cleaned up at the end
cluster -i ${negcon} --zthresh=3.09 --othresh=negThresh_${negcontrast} --minextent=25 --mm > negThresh_${negcontrast}.txt
done 

# 3. ADD NEGATIVE BACK TO POSITIVE NIFTI
#   now that positive and negative contrasts are both thresholded at z > 3.09, k >25,
#       we want the negative and positive niftis to be put into one file
# First, specify the thresholded image for the negative contrast (outputted from section above)
negNiftisThresh="negThresh_*.nii.gz"
# For loop that creates the thresholded images
for negconthresh in $negNiftisThresh; do
#   get the contrast name of interest (WITH THE .nii.gz extension)
contrastThresh=$(echo $negconthresh|cut -d '_' -f2);
#   Multiply the threshold negative contrast by -1 (b/c orig. it only had positive values for thresholding in FSL)
#      & then add the negative and positive clusters to get the full nifti
#   Outputs as "fullThresh_*" to indicate negative and positive thresholded images are now in same image
fslmaths negThresh_${contrastThresh} -mul -1 -add posThresh_${contrastThresh} fullThresh_${contrastThresh}
# Clean up directory
#   negative and positive thresholded images (that are separate) get put into "threshContrasts"
#   the full image (negative and positive are put into one) get put into "fullThreshContrasts"
mv negThresh_${contrastThresh} ExtractClusters/clusterNifti/threshContrasts
mv posThresh_${contrastThresh} ExtractClusters/clusterNifti/threshContrasts
mv fullThresh_${contrastThresh} ExtractClusters/clusterNifti/fullThreshContrasts
done 

# 4. FINALIZE DIRECTORY STRUCTURE
#   Move negative contrast text w/ relevant statistics
mv negThresh_*.txt ExtractClusters/clusterTexts/thresh
#   Move positive contrast text w/ relevant statistics
mv posThresh_*.txt ExtractClusters/clusterTexts/thresh