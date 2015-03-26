function analysis=cuplCrosscorrelation(analysis)
%CUPLCROSSCORRELATION  Calculate crosscorrelations
%
%   ANALYSIS = CUPLCROSSCORRELATION(ANALYSIS) Calculates crosscorrelations for
%   the files specified in ANALYSIS. Returns same structure with results
%   appended.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

% Alias analysis.
an = analysis;

% Lag times.
numLags = floor((an.maxTrackLength-1)/2);
crosscorrs.t = [-1*an.time(numLags+1:-1:2); an.time(1:numLags+1)];
crosscorrs.numLags = numLags;

% Compute change in sister centre position in normal axis.
delX1 = diff(an.sisterCoords1(:,1:3:end));
delX2 = diff(an.sisterCoords2(:,1:3:end));
delC = diff(an.sisterCentreCoords(:,1:3:end));

x1 = an.sisterCoords1(:,1:3:end);
x1 = x1 - repmat(nanmean(x1,1),an.maxTrackLength,1);
x2 = an.sisterCoords2(:,1:3:end);
x2 = x2 - repmat(nanmean(x2,1),an.maxTrackLength,1);
xc = an.sisterCentreCoords(:,1:3:end);
xc = xc - repmat(nanmean(xc,1),an.maxTrackLength,1);

% Compute correlations between sisters pairs.
crosscorrs.sisters.sister.dx = crosscorrelation(delX1,delX2,numLags);
crosscorrs.sisters.sister.x = crosscorrelation(x1,x2,numLags);

% Compute correlations between pair centres.
crosscorrs.sisters.pair.dx = crosscorrelation(...
  delC(:,an.pairIdx.sisters.pair(:,1)),...
  delC(:,an.pairIdx.sisters.pair(:,2)),numLags);
crosscorrs.sisters.pair.x = crosscorrelation(...
  xc(:,an.pairIdx.sisters.pair(:,1)),...
  xc(:,an.pairIdx.sisters.pair(:,2)),numLags);

% Compute correlations between individual sisters.
delX = [delX1 delX2];
crosscorrs.sisters.ind.dx = crosscorrelation(...
  delX(:,an.pairIdx.sisters.ind(:,5)), delX(:,an.pairIdx.sisters.ind(:,6)),...
  numLags);
x = [x1 x2];
crosscorrs.sisters.ind.x = crosscorrelation(...
  x(:,an.pairIdx.sisters.ind(:,5)), x(:,an.pairIdx.sisters.ind(:,6)),...
  numLags);

% Aggregate autocorrelation overall.
crosscorrs.sisters.ind.m_dx = nanmean(crosscorrs.sisters.ind.dx,2);
crosscorrs.sisters.ind.s_dx = nanstd(crosscorrs.sisters.ind.dx,0,2);
crosscorrs.sisters.ind.e_dx = nanserr(crosscorrs.sisters.ind.dx,2);
crosscorrs.sisters.pair.m_dx = nanmean(crosscorrs.sisters.pair.dx,2);
crosscorrs.sisters.pair.s_dx = nanstd(crosscorrs.sisters.pair.dx,0,2);
crosscorrs.sisters.pair.e_dx = nanserr(crosscorrs.sisters.pair.dx,2);
crosscorrs.sisters.sister.m_dx = nanmean(crosscorrs.sisters.sister.dx,2);
crosscorrs.sisters.sister.s_dx = nanstd(crosscorrs.sisters.sister.dx,0,2);
crosscorrs.sisters.sister.e_dx = nanserr(crosscorrs.sisters.sister.dx,2);

crosscorrs.sisters.ind.m_x = nanmean(crosscorrs.sisters.ind.x,2);
crosscorrs.sisters.ind.s_x = nanstd(crosscorrs.sisters.ind.x,0,2);
crosscorrs.sisters.ind.e_x = nanserr(crosscorrs.sisters.ind.x,2);
crosscorrs.sisters.pair.m_x = nanmean(crosscorrs.sisters.pair.x,2);
crosscorrs.sisters.pair.s_x = nanstd(crosscorrs.sisters.pair.x,0,2);
crosscorrs.sisters.pair.e_x = nanserr(crosscorrs.sisters.pair.x,2);
crosscorrs.sisters.sister.m_x = nanmean(crosscorrs.sisters.sister.x,2);
crosscorrs.sisters.sister.s_x = nanstd(crosscorrs.sisters.sister.x,0,2);
crosscorrs.sisters.sister.e_x = nanserr(crosscorrs.sisters.sister.x,2);

% TODO cell means

% Store result.
an.crosscorrs = crosscorrs;

% Record stage.
an.stages = union(an.stages,'crosscorrs');

% Unalias analysis.
analysis = an;

% Save analysis mat.
cuplSaveMat(analysis);
