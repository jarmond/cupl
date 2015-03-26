function analysis=cuplAskParameters(analysis)
%CUPLASKPARAMETERS  Ask user for parameters
%
%   ANALYSIS = CUPLASKPARAMETERS(ANALYSIS) Shows a dialog box asking for
%   analysis parameters. Returns ANALYSIS with parameters appended.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

% TODO generate from some sane data structure
defaultParams = {'0.25','2','7.5','12','12','3','8','1','1','0','0','1','0'};
responses = inputdlg({'Fraction NaNs to allow (0-1)',...
                      'Minimum accepted sisters per cell',...
                      'Frame interval (s)',...
                      'Number of bins for by dist',...
                      'Max dist for by dist bins (um)',...
                      'Threshold dist for neighbours (um)',...
                      'Max monotelic angle (degrees)',...
                      'Tracking channel',...
                      'Intensity channel',...
                      'Inspect cells? (0 or 1)',...
                      'Correct for cell drift (0, 1 or 2)',...
                      'Keep all data? (0 or 1)',...
                      'Analyse tracks? (0 or 1)'},...
                    'Enter analysis parameters',1,defaultParams);
if isempty(responses)
    responses = defaultParams;
end

% TODO: sanity check responses
analysis.options.percentNan = str2double(responses{1});
analysis.options.minSistersPerCell = str2double(responses{2});
analysis.options.frameInterval = str2double(responses{3});
analysis.options.byDistNumBins = str2double(responses{4});
analysis.options.byDistMaxWidth = str2double(responses{5});
analysis.options.neighbourThreshold = str2double(responses{6});
analysis.options.monotelicAngle = str2double(responses{7});
analysis.options.trackChannel = str2double(responses{8});
analysis.options.channel = str2double(responses{9});
if str2double(responses{10}) == 0
  analysis.stages = union(analysis.stages,'inspected');
end
analysis.options.correctDrift = str2double(responses{11});
analysis.options.keepAllData = str2double(responses{12});
analysis.options.doTracks = str2double(responses{13});

% Save analysis mat.
cuplSaveMat(analysis);
