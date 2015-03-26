function analysis=cuplSelectFiles(directory,useAllFiles)
% CUPLSELECTFILES Select tracking output files to analyse.
%
%   ANALYSIS = CUPLSELECTFILES(DIRECTORY,USEALLFILES) finds all maki output
%   files in the directory, including subdirectories, displays them in a GUI and
%   allows user to choose which files to analyse.  Returns ANALYSIS structure
%   containing filenames.
%
%   DIRECTORY Optional. If omitted user is asked to choose a directory.
%
%   USEALLFILES Optional. If 1, don't ask which files to analyse - take 'em
%   all.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1 || isempty(directory)
  % Directory not specified; ask user.
  directory = uigetdir('','Directory to search for data');
  if ~directory
    error('No directory selected.');
  end
end
if nargin<2
  useAllFiles = 0;
end

analysis.dataDirectory = directory;

% Search directory tree for maki files.
prefix = 'sisterList';
availableFiles = cuplFindFilesWithPrefix(directory,prefix);
availableFiles = [availableFiles; cuplFindFilesWithPrefix(directory,'kittracking')];

% Strip common data directory from beginning of paths.
k = length(directory);
if directory(end) ~= filesep
    k=k+1; % Take off path separator if not included in directory.
end
for i=1:length(availableFiles)
    availableFiles{i} = availableFiles{i}(k+1:end);
end

if useAllFiles
  analysis.dataFilenames = availableFiles;
else  
  % Show file chooser GUI.
  analysis.dataFilenames = fileChooser(availableFiles);
end

% Can't save analysis mat yet, don't know outfile.
