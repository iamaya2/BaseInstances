%%
% Cleanup and package loading
clc
clear
close all

% addpath(genpath('..\..\')); % Adds all Github packages
addpath(genpath('..\..\MatHH')); % Adds MatHH package

%% Read files from subfolder using 'dir'
baseLocation = 'files\';

% % For old Taillard instances (source: unknown)
% instanceFolder = 'Instances\Taillard1515New\';
% Flag definition:
% isFromTaillardWeb = false; % Not from Taillard's website
% isFromORLib = false; % Not from the OR-Library

% % For Taillard instances (source: http://mistic.heig-vd.ch/taillard/problemes.dir/ordonnancement.dir/ordonnancement.html)
% % instanceFolder = 'Instances\TaillardWeb1515\';
% % instanceFolder = 'Instances\TaillardWeb2015\';
% % instanceFolder = 'Instances\TaillardWeb2020\';
% % instanceFolder = 'Instances\TaillardWeb3015\';
% % instanceFolder = 'Instances\TaillardWeb3020\';
% % instanceFolder = 'Instances\TaillardWeb5015\';
% % instanceFolder = 'Instances\TaillardWeb5020\';
% instanceFolder = 'Instances\TaillardWeb10020\';
% % Flag definition:
% isFromTaillardWeb = true; % From Taillard's website
% isFromORLib = false; % Not from the OR-Library

% For OR-Library instances (source: http://people.brunel.ac.uk/~mastjjb/jeb/orlib/files/jobshop1.txt)
instanceFolder = 'Instances\ORLibrary\';
% Flag definition:
isFromTaillardWeb = false; % From Taillard's website
isFromORLib = true; % Not from the OR-Library

txtFileName = [baseLocation 'txt\' instanceFolder '*.txt'];
allFiles    = dir(txtFileName);
nbFiles     = length(allFiles);

%% Process files
if ~isFromTaillardWeb
    if ~isFromORLib
        % Process all files
        for idF = nbFiles : -1 : 1
            % load text file as table
            thisFileName = [baseLocation 'txt\' instanceFolder allFiles(idF).name];
            tableInstance = readtable(thisFileName, 'TreatAsEmpty','MACHINES');
            
            % Process table to remove nan row (assumes one squared instance per file)
            nbInstances = (size(tableInstance,1)-1)/2;
            rawInstanceData(:,:,1) = tableInstance{1:nbInstances,1:nbInstances};
            rawInstanceData(:,:,2) = tableInstance{nbInstances+2:end,1:nbInstances}; % one extra skip because of the nan row
            
            % Build JSSPInstance object
            allInstances(idF) = JSSPInstance(rawInstanceData);
        end
    else
        for idF = nbFiles : -1 : 1
            % load text file as raw data
            thisFileName = [baseLocation 'txt\' instanceFolder allFiles(idF).name];
            fileID = fopen(thisFileName);
            
            % Scan text until the file ends
            instanceCounter = 0; % Assume there are no instances
            while true
                thisLine = fgetl(fileID);
                if thisLine == -1, break; end % Break when file ends
                if ~isempty(thisLine)
                    scannedData = textscan(thisLine,'%f');
                    lineData = scannedData{1};
                    if length(lineData) == 2 % header line with instance data
                        instanceCounter = instanceCounter + 1; % Instance detected
                        nbJobs = lineData(1);
                        maxMachineID = lineData(2);
                        
                        clear allJobs % Ensure that there is no extra information from previous iterations
                        allJobs(nbJobs) = JSSPJob(); % Reserve memory with dummy job
                        for idJ = 1 : nbJobs % Read the lines with processing times
                            thisLine = fgetl(fileID);
                            scannedData = textscan(thisLine,'%f');
                            lineData = scannedData{1};
                            machineLocations = lineData(1:2:end)+1; % extract machine data and fix to start at one
                            procTimes = lineData(2:2:end); % extract processing time data
                            
                            % Validate that data length matches
                            if length(machineLocations) ~= length(procTimes), error('Instance not read properly. Abort!'); end
                            
                            % Create and store this job
                            allJobs(idJ) = JSSPJob(machineLocations,procTimes,idJ);
                        end
                        
                        allInstances{instanceCounter} = JSSPInstance(allJobs, maxMachineID); % Store instance
                    end
                end
            end
            
            fclose(fileID);
        end
    end
else
    for idF = nbFiles : -1 : 1
        % load text file as raw data
        thisFileName = [baseLocation 'txt\' instanceFolder allFiles(idF).name];
        fileID = fopen(thisFileName);
        
        % Scan text until the file ends
        instanceCounter = 0; % Assume there are no instances
        while true
            thisLine = fgetl(fileID);
            if thisLine == -1, break; end % Break when file ends
            scannedData = textscan(thisLine,'%f');
            lineData = scannedData{1};
            if length(lineData) == 6 % header line with instance data
                instanceCounter = instanceCounter + 1; % Instance detected
                nbJobs = lineData(1);
                maxMachineID = lineData(2);
                
                dummyLine = fgetl(fileID); % should read 'Times'
                thisInstanceRawData = nan(nbJobs, maxMachineID, 2); % Taillard instances have nbMachines == maxMachineID
                
                for idJ = 1 : nbJobs % Read the lines with processing times
                    thisLine = fgetl(fileID);
                    scannedData = textscan(thisLine,'%f');
                    lineData = scannedData{1};
                    thisInstanceRawData(idJ,:,1) = lineData;
                end
                
                dummyLine = fgetl(fileID); % should read 'Machines'
                if ~strcmpi(dummyLine,'machines') % Validate that everything is going OK
                    error('Error reading file. Machine header text was not read properly. Aborting!')
                end
                
                for idJ = 1 : nbJobs % Read the lines with machine IDs
                    thisLine = fgetl(fileID);
                    scannedData = textscan(thisLine,'%f');
                    lineData = scannedData{1};
                    thisInstanceRawData(idJ,:,2) = lineData;
                end
                
                allInstances{instanceCounter} = JSSPInstance(thisInstanceRawData); % Store instance
            end
        end
        
        fclose(fileID);
    end
end

% Store set of instances for later use
matFileName = [baseLocation 'mat\' instanceFolder 'instanceDataset.mat'];
save(matFileName, 'allInstances')