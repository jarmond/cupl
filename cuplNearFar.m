function analysis=cuplNearFar(analysis)
% CUPLNEARFAR  Average cross-correlations for nearest and furthest
%
%   ANALYSIS = CUPLNEARFAR(ANALYSIS) Calculates average crosscorrelations for
%   nearest and furthest pairs of KTs. Returns same structure with results
%   appended.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

% Alias analysis.
an = analysis;

corrLength = size(an.crosscorrs.sisters.ind.dx,1);
nearCrossInd = zeros(corrLength,an.nSisters);
farCrossInd = zeros(corrLength,an.nSisters);
nearCrossPair = zeros(corrLength,an.nSisters);
farCrossPair = zeros(corrLength,an.nSisters);

for i=1:an.nSisters
  % i is accepted sister index.

  % Individual kinetochores.
  % Index of pairs containing sister j.
  pairs = find(an.pairIdx.sisters.ind(:,1) == i | ...
               an.pairIdx.sisters.ind(:,2) == i);
  % Index into pairs of maximum/minimum separation.
  [~,maxIdx] = max(an.distances.sisters.ind.d(pairs));
  [~,minIdx] = min(an.distances.sisters.ind.d(pairs));
  % Extract appropriate crosscorrelations.
  farCrossInd(:,i) = an.crosscorrs.sisters.ind.dx(:,pairs(maxIdx));
  nearCrossInd(:,i) = an.crosscorrs.sisters.ind.dx(:,pairs(minIdx));

  % Pair centres.
  % Index of pairs containing sister j.
  pairs = find(an.pairIdx.sisters.pair(:,1) == i | ...
               an.pairIdx.sisters.pair(:,2) == i);
  % Index into pairs of maximum/minimum separation.
  [~,maxIdx] = max(an.distances.sisters.pair.d(pairs));
  [~,minIdx] = min(an.distances.sisters.pair.d(pairs));
  % Extract appropriate crosscorrelations.
  farCrossPair(:,i) = an.crosscorrs.sisters.pair.dx(:,pairs(maxIdx));
  nearCrossPair(:,i) = an.crosscorrs.sisters.pair.dx(:,pairs(minIdx));

end

% Aggregate and store.
an.crosscorrs.sisters.ind.near_m_dx = nanmean(nearCrossInd,2);
an.crosscorrs.sisters.ind.near_s_dx = nanstd(nearCrossInd,0,2);
an.crosscorrs.sisters.ind.near_e_dx = nanserr(nearCrossInd,2);
an.crosscorrs.sisters.ind.far_m_dx = nanmean(farCrossInd,2);
an.crosscorrs.sisters.ind.far_s_dx = nanstd(farCrossInd,0,2);
an.crosscorrs.sisters.ind.far_e_dx = nanserr(farCrossInd,2);

an.crosscorrs.sisters.pair.near_m_dx = nanmean(nearCrossPair,2);
an.crosscorrs.sisters.pair.near_s_dx = nanstd(nearCrossPair,0,2);
an.crosscorrs.sisters.pair.near_e_dx = nanserr(nearCrossPair,2);
an.crosscorrs.sisters.pair.far_m_dx = nanmean(farCrossPair,2);
an.crosscorrs.sisters.pair.far_s_dx = nanstd(farCrossPair,0,2);
an.crosscorrs.sisters.pair.far_e_dx = nanserr(farCrossPair,2);


% Record stage.
an.stages = union(an.stages,'nearfar');

% Unalias analysis.
analysis = an;

% Save analysis mat.
cuplSaveMat(analysis);
