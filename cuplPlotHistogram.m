function cuplPlotHistogram(x,varargin)
%CUPLPLOTHISTOGRAM  Draws correlation plot
%
%   CUPLPLOTHISTOGRAM(X) Draws histogram of values X.
%
%   CUPLPLOTHISTOGRAM(X,...) Options for plotting can be specified
%   as string/variable pairs, as follows:
%
%       'PlotTitle': Add title to top of graph (String).
%
%       'PlotYlim': Limit y-axis (2-element float vector).
%
%       'NumBins': Number of bins for histogram (Integer; Default 10).
%
%       'Output': Save plot to file (String).
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

% Defaults.
plotTitle = '';
plotYLim = [];
output = [];
numBins = 10;
plotXLabel = 'Distance (\mum)';
plotYLabel = 'Correlation';

% Read options.
options = {'plotTitle','plotYLim','output','numBins','plotXLabel','plotYLabel'};
for i=1:2:length(varargin)
    name = lower(varargin{i});
    value = varargin{i+1};
    matches = strcmp(lower(options),name);
    if all(matches==0)
        error(['Unknown option: ' name]);
    end
    idx = find(matches,1);
    eval([options{idx} '=value;']);
end

% Create figure.
h = figure;
[n,xout] = hist(x,numBins);
% Make relative.
n = n/length(x);
if length(unique(x))<length(x)
    % Degenerate histogram, plot standard version.
    hist(x,numBins);
else
    bar(xout,n);
end

if ~isempty(plotYLim)
    ylim(plotYLim);
end

% Label graph.
xlabel(plotXLabel);
ylabel(plotYLabel);
title(plotTitle);

% Annotate graph.
fontSize = 8;
xl = xlim;
yl = ylim;
xText = 0.75*diff(xl)+xl(1);
yText = 0.95*diff(yl)-yl(2);
yTextHeight = 0.05*max(yl); 
text(xText,yText,['mean = ' num2str(nanmean(x),'%.4f ')],'FontSize',fontSize);
text(xText,yText-yTextHeight,['median = ' num2str(nanmedian(x),'%.4f ')],'FontSize',fontSize);
text(xText,yText-2*yTextHeight,['std = ' num2str(nanstd(x),'%.4f ')],'FontSize',fontSize);
text(xText,yText-3*yTextHeight,['n = ' num2str(sum(~isnan(x)))],'FontSize',fontSize);

% Save.
if ~isempty(output)
    saveas(gcf,output);
    dlmwrite(strrep(output,'pdf','csv'),[xout; n]','precision',6);
end
