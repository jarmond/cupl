function plots=cuplValidPlots(analysis)
% CUPLVALIDPLOTS Return plots valid for given analysis data
%
%   PLOTS = CUPLASKPLOTS(ANALYSIS) Return plot info valid for given analysis
%   data draw as cell array. PLOTS is a Nx2 cell array with the plot
%   description in the first column and plot id in the second column.
%
%   
%
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

% Plot descriptions, ids and required field.
plotTypes = {
  'Average autocorrelelogram','avgauto','autocorrs';
  'Average cross-correlelogram','avgcross','crosscorrs';
  'Correlation by distance','corrdist','corrdist';
  'Distance histogram','disthist','distances';
  'Speeds histogram','speedhist','speeds';
  'Mean-squared displacement','msd','msd';
  'Phase shifts by distance','phaseshifts','phaseshifts';
  'Monopolar correlation by central angle','monopoleangle','monopoleangle'};
nPlotTypes = size(plotTypes,1);

% Check which plots are possible with analysis data.
validTypes = [];
for i=1:nPlotTypes
  if isfield(analysis,plotTypes{i,3})
    validTypes(end+1) = i;
  end
end

% Return ids of selected plots.
plots = plotTypes(validTypes,1:2);
