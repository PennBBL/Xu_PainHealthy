% Figure Generator
% ----------------------------------------
% Uses BrainNet to generate pretty brain images
% With the templates defaulted to my own
%
% Input:
%   type = 'main', 'contrast', or 'conjunction
%   figure = nifti file path (as a string)
%   output = name of output (as a string -- e.g., 'SOMETHING.jpg')
% Output: 
%   .jpg of the BrainNet-generated figure
%
% NB: templates for the figures are specified in the subfolder
% figureTemplates from the main directory
% ----------------------------------------
% AX 03/26/2019 -- updated to use default volume data range

function gen_figure(type,figure,output)
% choice of template depending on which type
if strcmpi(type, 'main')
    template='figureTemplates/mainEffectCfg_latMed.mat';
elseif strcmpi(type, 'contrast')
    template='figureTemplates/contrastCfg_latMed.mat';
elseif strcmpi(type, 'conjunction')
   template='figureTemplates/conjunctionCfg_latMed.mat';
else disp('Error: type can only be main, contrast, or conjunction')
end

% calculate brain volume range
[px, nx, pn, ] = brainVolRange(figure);

% load the proper template
load(template);

% set to min,max of brain volume
EC.vol.pn=pn;
EC.vol.px=px;
EC.vol.nx=nx;
if strcmpi(type, 'contrast')
    EC.vol.pn=0.01;
    EC.vol.nn=-0.01;
end

% save this .mat file since we're using it as the new config
save('EC.mat');

% create the image
BrainNet_MapCfg('BrainMesh_ICBM152.nv', figure, 'EC.mat', output);

% delete the EC
delete('EC.mat'); 
clear EC % also delete the variable so that a new one can be used
end 
