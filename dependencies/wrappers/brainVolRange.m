% BrainVolRange
% ----------------------------------------
% Gets the volume data range of a nifti
% Input:
%    nifti = nifti file (as a string)
% Output: 
%   positive max, negative max, positive min, negative min
% Uses SPM functions to read volumes 
%
% NB: original use was to set default scales on BrainNet as min,max
% ----------------------------------------
% AX 03/26/2019

function [brainVol_px, brainVol_nx, brainVol_pn, brainVol_nn] = brainVolRange(nifti)

V=spm_vol(nifti);
img=spm_read_vols(V);

% get maximum
brainVol_px=max(max(max(img))); % positive
brainVol_nx=min(min(min(img))); % negative

% get minimum
brainVol_pn=min(img(img>0)); % positive
brainVol_nn=(min(abs(img((abs(img)>0) & (img<0))))) * -1; % negative

end 