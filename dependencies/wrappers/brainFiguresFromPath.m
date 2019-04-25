% Generate brain figures from a specified path
% ----------------------
% Uses the function gen_figure() to generate a .jpg file for all the
% niftis in a specified path
%
% I/P: (1) string specifying type of effect nifti shows 
%           (e.g., 'main', 'contrast, 'conjunction')
%      (2) number of figures in the path
%      (3) the path where the files are
% O/P: .jpg files resulting from gen_figure()
% ----------------------
% Written by AX 04/01/2019


function brainFiguresFromPath(type, num, path)
files = dir(path);
for i=1:num
    fileName=files(i).name;
    % get the effect name
    effectsName=split(fileName, ".")';
    effectsName=cell2mat(effectsName(1));
    % output name
    outputName=strcat(effectsName, '.jpg');
    % generate the figure
    gen_figure(type, fileName, outputName);
end
end 