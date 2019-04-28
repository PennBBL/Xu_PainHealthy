%% Compute ALE for PainHealthy Project
% by AX 04/01/2019
% -------------------------------------
% This script is a higher-level script that runs all operations pertaining to
% computing ALE (using Eickhoff's scripts)
%   a) thresholds the main effects clusters at z>3.09
%   b) generates the negative & positive contrast images for contrasts
%   c) thresholds the contrast clusters at a liberal threshold of z>1.6 and k>50
%       % N.B. : this will eventually get re-thresholded with FSL at z>3.09
%   d) thresholds the conjunction clusters at z>3.09 and k>15
% -------------------------------------

%% Setup

setupPath(pwd);
cd EickhoffALE

%% Script
    % input coordinates
ale_inputCoords('data/painHealthyCoords_20190426.xls');
    % run analyses
ale_estimateALE('contrasts/painHealthyAnalyses_20190401.xlsx');
