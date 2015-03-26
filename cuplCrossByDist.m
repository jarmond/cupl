function analysis=cuplCrossByDist(analysis)
% CUPLCROSSBYDIST  Bin cross-correlations by distance
%
%   ANALYSIS = CUPLCROSSBYDIST(ANALYSIS) Calculates average crosscorrelations
%   for the files specified in ANALYSIS. Returns same structure with results
%   appended.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

% Alias analysis.
an = analysis;

range = [0 an.options.byDistMaxWidth];

% Bin correlations by distance, for each lag.
numBins = an.options.byDistNumBins;
x.ind = an.distances.sisters.ind.d;
x.pair = an.distances.sisters.pair.d;
x.sister = an.distances.sisters.sister.d;
y.ind = an.crosscorrs.sisters.ind.dx'; % Make lags in columns
y.pair = an.crosscorrs.sisters.pair.dx';
y.sister = an.crosscorrs.sisters.sister.dx';
an.corrdist.sisters = cuplBinByValue(x,y,{'ind','pair','sister'},numBins,range);

% Bin correlation by distance of correlation of x.
y.ind = an.crosscorrs.sisters.ind.x'; % Make lags in columns
y.pair = an.crosscorrs.sisters.pair.x';
y.sister = an.crosscorrs.sisters.sister.x';
an.corrdist.sistersx = cuplBinByValue(x,y,{'ind','pair','sister'},numBins,range);

% Bin min of correlation by distance.
y.ind = nanmin(an.crosscorrs.sisters.ind.dx)';
y.pair = nanmin(an.crosscorrs.sisters.pair.dx)';
y.sister = nanmin(an.crosscorrs.sisters.sister.dx)';
an.corrdist.sistersmin = cuplBinByValue(x,y,{'ind','pair','sister'},numBins,range);

% Bin min of correlation by distance.
y.ind = nanmax(an.crosscorrs.sisters.ind.dx)';
y.pair = nanmax(an.crosscorrs.sisters.pair.dx)';
y.sister = nanmax(an.crosscorrs.sisters.sister.dx)';
an.corrdist.sistersmax = cuplBinByValue(x,y,{'ind','pair','sister'},numBins,range);

y.ind = nanmin(an.crosscorrs.sisters.ind.x)';
y.pair = nanmin(an.crosscorrs.sisters.pair.x)';
y.sister = nanmin(an.crosscorrs.sisters.sister.x)';
an.corrdist.sistersxmin = cuplBinByValue(x,y,{'ind','pair','sister'},numBins,range);

y.ind = nanmax(an.crosscorrs.sisters.ind.x)';
y.pair = nanmax(an.crosscorrs.sisters.pair.x)';
y.sister = nanmax(an.crosscorrs.sisters.sister.x)';
an.corrdist.sistersxmax = cuplBinByValue(x,y,{'ind','pair','sister'},numBins,range);

% Bin argmax of correlation.
t = an.crosscorrs.t;
[~,y.ind] = nanmax(an.crosscorrs.sisters.ind.dx);
y.ind = abs(t(y.ind));
[~,y.pair] = nanmax(an.crosscorrs.sisters.pair.dx);
y.pair = abs(t(y.pair));
[~,y.sister] = nanmax(an.crosscorrs.sisters.sister.dx);
y.sister = abs(t(y.sister));
an.corrdist.sistersargmax = cuplBinByValue(x,y,{'ind','pair','sister'},numBins,range);

[~,y.ind] = nanmax(an.crosscorrs.sisters.ind.x);
y.ind = abs(t(y.ind));
[~,y.pair] = nanmax(an.crosscorrs.sisters.pair.x);
y.pair = abs(t(y.pair));
[~,y.sister] = nanmax(an.crosscorrs.sisters.sister.x);
y.sister = abs(t(y.sister));
an.corrdist.sistersxargmax = cuplBinByValue(x,y,{'ind','pair','sister'},numBins,range);


% Record stage.
an.stages = union(an.stages,'corrdist');

% Unalias analysis.
analysis = an;

% Save analysis mat.
cuplSaveMat(analysis);
