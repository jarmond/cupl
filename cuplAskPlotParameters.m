function analysis=cuplAskPlotParameters(analysis,plots)
% CUPLASKPLOTPARAMETERS  Ask user for plot parameters
%
%   ANALYSIS = CUPLASKPLOTPARAMETERS(ANALYSIS,PLOTS) Shows a dialog box asking
%   for plotting parameters. Returns ANALYSIS with parameters appended.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

defaultParams = {'krbgmcy','0'};
responses = inputdlg({'Line colour sequence',...
                      'Max correlation time'},...
                    'Enter plot parameters',1,defaultParams);
if isempty(responses)
    responses = defaultParams;
end

% TODO: sanity check responses
analysis.plotOptions.colours = responses{1};
analysis.plotOptions.maxTime = str2num(responses{2});


% Save analysis mat.
cuplSaveMat(analysis);
