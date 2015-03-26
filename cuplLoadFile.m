function data=cuplLoadFile(analysis,i)
% CUPLLOADFILE  Load tracking data file number i
%
%   DATA = CUPLLOADFILE(ANALYSIS,I) Loads tracking data file number I and
%   returns dataStruct for analysis.channel (only appropriate for KiT
%   multichannel output).
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

if i<=0 || i>length(analysis.dataFilenames)
    error(['No such file ' num2str(i)]);
end

% Load data.
data = load(fullfile(analysis.dataDirectory, analysis.dataFilenames{i}));

% Check if output from KiT.
isKit = (isfield(data,'kit') && data.kit == 1);
if (isfield(data,'failed') && data.failed == 1) || ~isfield(data,'dataStruct')
  warning('Tracking of file %s seems to have failed',analysis.dataFilenames{i});
  data = [];
  return;
end

if isKit || analysis.options.trackChannel > 1
  if ~isKit
    warning('Assuming KiT output since tracking channel > 1');
  end
  data = data.dataStruct{analysis.options.trackChannel};
end
