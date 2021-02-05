% Cleanup and package loading
clc
clear
close all

addpath(genpath("..\..\")); % Adds all Github packages

% Read files from subfolder using 'dir'
baseLocation = 'files\';
instanceFolder = 'Instances\artJOSH\Tai_15_15\';
baseFileName = [baseLocation 'mat\' instanceFolder '*.mat'];
allFiles    = dir(baseFileName);
nbFiles     = length(allFiles);

% Process all files
for idF = nbFiles : -1 : 1
    % load text file as table
    thisFileName = [baseLocation 'mat\' instanceFolder allFiles(idF).name];
    load(thisFileName);
%     tableInstance = readtable(thisFileName, 'TreatAsEmpty','MACHINES');
    
%     % Process table to remove nan row (assumes one squared instance per file)
%     nbInstances = (size(tableInstance,1)-1)/2;
%     rawInstanceData(:,:,1) = tableInstance{1:nbInstances,1:nbInstances};
%     rawInstanceData(:,:,2) = tableInstance{nbInstances+2:end,1:nbInstances}; % one extra skip because of the nan row
    
    % Build JSSPInstance object
    allInstances(idF) = Instance;    
end

% Store set of instances for later use
matFileName = [baseLocation 'mat\' instanceFolder 'final\instanceDataset.mat'];
save(matFileName, 'allInstances')