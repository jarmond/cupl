function plots=cuplAskPlots(analysis)
% CUPLASKPLOTS  Ask user which plots to make
%
%   PLOTS = CUPLASKPLOTS(ANALYSIS) Shows a dialog box asking which plots to
%   draw. Returns cell array of plot ids.
%
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

% Get list of valid plots.
plotTypes = cuplValidPlots(analysis);
if isempty(plotTypes)
  warning('No valid plots available for this analysis.');
  return
end

% Prompt user for plot types.
selection = listdlg('promptstring','Select plots to draw',...
                    'okstring','Plot',...
                    'liststring',plotTypes(:,1));

% Return ids of selected plots.
plots = plotTypes(selection,2);
