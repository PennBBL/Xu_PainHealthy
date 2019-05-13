niftiMainEffect="EickhoffALE/ALE/Results/*_cFWE05.nii"

for main in $niftiMainEffect; do
#   Extract the name of the main effects (e.g., "thermal" from the file "thermal_cFWE05.nii")
    mainEffectName=$(echo $main|cut -d '/' -f4|cut -d '_' -f1);
#   Extract the cluster statistics, thresholded voxelwise at z > 3.09
#   Outputs: nifti with thresholded image; text file with the statistics
#       - the thresholded image will essentially be the same as the ALE output in "EickhoffALE/ALE/Results/*_cFWE05.nii"
#       ----this is because the ALE outputted map was already thresholded at z > 3.09    
    fslmaths ${main} -bin ${mainEffectName}_bin 
done


fslmaths activation_bin.nii.gz -add armLeg_bin.nii.gz -add chemical_bin.nii.gz -add electrical_bin.nii.gz -add female_bin.nii.gz -add handFoot_bin.nii.gz -add left_bin.nii.gz -add male_bin.nii.gz -add mechanical_bin.nii.gz -add notVisceral_bin.nii.gz -add otherMod_bin.nii.gz -add painInnoc_bin.nii.gz -add right_bin.nii.gz -add thermal_bin.nii.gz -add visceral_bin.nii.gz overlap_map_bin.nii.gz