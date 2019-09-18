niftiMainEffect="EickhoffALE/ALE/Results/*_cFWE05.nii"

for main in $niftiMainEffect; do
#   Extract the name of the main effects (e.g., "thermal" from the file "thermal_cFWE05.nii")
    mainEffectName=$(echo $main|cut -d '/' -f4|cut -d '_' -f1);
#   Binarize each main effects map
#   Outputs: nifti binarized (1 if convergent activation was present)
    fslmaths ${main} -bin ${mainEffectName}_bin
done

# add the figures on top of each other to view overlap
fslmaths activation_bin.nii.gz -add armLeg_bin.nii.gz -add chemical_bin.nii.gz -add electrical_bin.nii.gz -add female_bin.nii.gz -add handFoot_bin.nii.gz -add left_bin.nii.gz -add male_bin.nii.gz -add mechanical_bin.nii.gz -add notVisceral_bin.nii.gz -add otherMod_bin.nii.gz -add painInnoc_bin.nii.gz -add painBaseline_bin.nii.gz -add right_bin.nii.gz -add thermal_bin.nii.gz -add visceral_bin.nii.gz overlap_map_bin.nii.gz
