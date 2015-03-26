function analysis=cuplMonopolar(analysis)
% CUPLMONOPOLAR  Calculate crosscorrelation for monopolar spindles
%
%   ANALYSIS = CUPLMONOPOLAR(ANALYSIS) Calculate crosscorrelation for monopolar
%   spindles for the files specified in ANALYSIS. Returns same structure with
%   results appended.
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
monopole.crosscorr.numLags = numLags;
monopole.crosscorr.t = [-1*an.time(numLags+1:-1:2); an.time(1:numLags+1)];
monopole.autocorr.numLags = numLags;
monopole.autocorr.t = an.time(1:numLags+1);

% Compute average position of each sister.
sisterPos1 = reshape(nanmean(an.sisterCoords1),3,an.nSisters)';
sisterPos2 = reshape(nanmean(an.sisterCoords2),3,an.nSisters)';

% Compute central angles between sisters. Assuming cell centre is origin.
sisterVecDot = dot(sisterPos1, sisterPos2, 2);
sisterVecMag = sqrt(sum(sisterPos1.^2,2)) .* sqrt(sum(sisterPos2.^2,2));
sisterAngle = acosd(sisterVecDot ./ sisterVecMag);

% Compute change in sister centre radial position.
sisterCols = indexToCols(1:an.nSisters);
sisterCols = reshape(sisterCols,3,an.nSisters)'; % indexes of x,y,z
radialPos = nan(an.maxTrackLength,an.nSisters);
radialPos1 = radialPos;
radialPos2 = radialPos;
for i=1:an.nSisters
  cellCols = indexToCols(an.sisterCellIdx(i));
  centre = an.cellCentres(:,cellCols);
  radialPos(:,i) = eudist(an.sisterCentreCoords(:,sisterCols(i,:)), centre);
  radialPos1(:,i) = eudist(an.sisterCoords1(:,sisterCols(i,:)), centre);
  radialPos2(:,i) = eudist(an.sisterCoords2(:,sisterCols(i,:)), centre);
end
monopole.radialPos = radialPos;
delR = diff(radialPos); % displacement
delR1 = diff(radialPos1);
delR2 = diff(radialPos2);

% Filter for monotelic sister pairs. Pairs with central angles larger than
% threshold are assumed to be non-monotelic.
smallAngles = sisterAngle < an.options.monotelicAngle;
monotelic = find(smallAngles);
monopole.angles.sisters = sisterAngle;
monopole.angles.monotelic = monotelic;

% Compute autocorrelations.
monopole.autocorr.pair.dr = autocorrelation(delR(:,monotelic),numLags);

% Aggregate autocorrelation overall.
monopole.autocorr.pair.m_dr = nanmean(monopole.autocorr.pair.dr,2);
monopole.autocorr.pair.s_dr = nanstd(monopole.autocorr.pair.dr,0,2);
monopole.autocorr.pair.e_dr = nanserr(monopole.autocorr.pair.dr,2);

% Compute correlations between pair centres.
% Filter out non-monotelic pairings.
leftRows=[];
rightRows=[];
for i=1:length(monotelic)
  leftRows = [leftRows; find(an.pairIdx.sisters.pair(:,1)==monotelic(i))];
  rightRows = [rightRows; find(an.pairIdx.sisters.pair(:,2)==monotelic(i))];
end
ii = intersect(leftRows,rightRows);
monopole.monotelicPairIdx = an.pairIdx.sisters.pair(ii,:);
monopole.crosscorr.pair.dr = crosscorrelation(...
  delR(:,monopole.monotelicPairIdx(:,1)),...
  delR(:,monopole.monotelicPairIdx(:,2)),numLags);

% Compute correlations between sisters.
monopole.crosscorr.sister.dr = crosscorrelation(...
  delR1(:,monotelic),delR2(:,monotelic),numLags);

% Aggregate crosscorrelation overall.
monopole.crosscorr.pair.m_dr = nanmean(monopole.crosscorr.pair.dr,2);
monopole.crosscorr.pair.s_dr = nanstd(monopole.crosscorr.pair.dr,0,2);
monopole.crosscorr.pair.e_dr = nanserr(monopole.crosscorr.pair.dr,2);
monopole.crosscorr.sister.m_dr = nanmean(monopole.crosscorr.sister.dr,2);
monopole.crosscorr.sister.s_dr = nanstd(monopole.crosscorr.sister.dr,0,2);
monopole.crosscorr.sister.e_dr = nanserr(monopole.crosscorr.sister.dr,2);

% Compute central angles.
% Vectors from cell centre to sister, assuming cell centre is origin.
sisterVecDot = dot(...
  an.sisterCentrePos(monopole.monotelicPairIdx(:,1),:),...
  an.sisterCentrePos(monopole.monotelicPairIdx(:,2),:), 2);
sisterVecMag = sqrt(sum(an.sisterCentrePos(monopole.monotelicPairIdx(:,1),:).^2,2)) .* ...
    sqrt(sum(an.sisterCentrePos(monopole.monotelicPairIdx(:,2),:).^2,2));
monopole.angles.pair.theta = acosd(sisterVecDot ./ sisterVecMag);


% TODO cell means

% Store result.
an.monopole = monopole;

% Record stage.
an.stages = union(an.stages,'monopole');

% Unalias analysis.
analysis = an;

% Save analysis mat.
cuplSaveMat(analysis);
