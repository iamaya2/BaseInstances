%%
% Cleanup and package loading
clc
clear
close all

%%
addpath(genpath('..\..\MatHH')); % Adds MatHH framework
% addpath(genpath("..\..\BaseInstances")); % Adds file locations - may not
% be required

% Read files from subfolder using 'dir'
baseLocation = 'files\';

% For LargeTA_Benchmark: ends without -1 values, some instances way too big
instanceFolder = 'Instances\LargeTA_Benchmark\'; 
EOLFlag = false; % ends without -1 values
singInstFlag = true; % Save instances separately due to size


% For KnownOptima_Benchmark: ends with -1 values
% instanceFolder = 'Instances\KnownOptima_Benchmark\'; 
% EOLFlag = true; % ends with -1 values
% singInstFlag = false; % All instances in a single object

txtFileName = [baseLocation 'data\' instanceFolder '*.data'];
allFiles    = dir(txtFileName);
nbFiles     = length(allFiles);

%%
% Process all files
allInstances(nbFiles) = JSSPInstance();
for idF = nbFiles : -1 : 1
    fprintf('Files remaining: %d\n', idF)
    % load text file as table
    thisFileName = [baseLocation 'data\' instanceFolder allFiles(idF).name];
    fileID = fopen(thisFileName);
    
    % Get info from first line to determine instance data
    thisLine = fgetl(fileID);
    scannedData = textscan(thisLine,'%f');
    lineData = scannedData{1};
    nbJobs = lineData(1);
    maxMachineID = lineData(2);
    clear allJobs % Ensure that there is no extra information from previous iterations
    allJobs(nbJobs) = JSSPJob(); % Reserve memory with dummy job
    for idL = 1 : nbJobs % Read data and store it
        thisLine = fgetl(fileID);
        scannedData = textscan(thisLine,'%f');
        lineData = scannedData{1};
        if EOLFlag, rawData = lineData(1:end-2); else, rawData = lineData; end % Remove -1 -1 that mark end of line
        machineLocations = rawData(1:2:end); % extract machine data
        procTimes = rawData(2:2:end); % extract processing time data
        
        % Validate that data length matches
        if length(machineLocations) ~= length(procTimes), error('Instance not read properly. Abort!'); end
        
        % Create and store this job
        thisJob = JSSPJob(machineLocations,procTimes,idL);
        allJobs(idL) = thisJob;
    end
    % Create instance using all jobs that were read from file
    thisInstance = JSSPInstance(allJobs, maxMachineID);
    % Store this instance in cell array and move to the next one
    allInstances(idF) = thisInstance;
    
    % Store set of instances for later use
    if singInstFlag
        matFileName = [baseLocation 'mat\' instanceFolder 'instanceDataset_I' num2str(idF,'%02d') '.mat'];
        save(matFileName, 'thisInstance')
    else
        matFileName = [baseLocation 'mat\' instanceFolder 'instanceDataset.mat'];
        save(matFileName, 'allInstances')
    end
end