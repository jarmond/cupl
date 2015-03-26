function analysis=cuplMonopolarByDist(analysis)
% CUPLMONOPOLARBYDIST  Bin monopolar cross-correlations by central angle
%
%   ANALYSIS = CUPLMONOPOLARBYDIST(ANALYSIS) Calculates monopolar
%   crosscorrelations binned by central angle between each pair for the files
%   specified in ANALYSIS. Returns same structure with results appended.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

% Alias analysis.
an = analysis;

% Bin correlations by distance, for each lag.
numBins = an.options.byDistNumBins;
x.pair = an.monopole.angles.pair.theta;
y.pair = an.monopole.crosscorr.pair.dr'; % Make lags in columns 
an.monopoleangle.sisters = cuplBinByValue(x,y,{'pair'},numBins);

% Record stage.
an.stages = union(an.stages,'monopoleangle');

% Unalias analysis.
analysis = an;

% Save analysis mat.
cuplSaveMat(analysis);
