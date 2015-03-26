function analysis=cuplNormalShifts(analysis)
% CUPLNORMALSHIFTS Calculate normal shifts
%
%   ANALYSIS = CUPLNORMALSHIFTS(ANALYSIS) Calculates normal shifts for the files
%   specified in ANALYSIS. Returns same structure with results appended.
%
%   Normal shifts are defined as the mean difference in X position between
%   various pairings of kinetochores, normalized to metaphase plate width.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

% Alias analysis.
an = analysis;

% Accepted sister X coordinates.
xCoords = an.sisterCentreCoords(:,1:3:end);
xCoords1 = an.sisterCoords1(:,1:3:end);
xCoords2 = an.sisterCoords2(:,1:3:end);

% Estimate metaphase plate width as mean of kinetochore travel range.
an.plateWidths = zeros(an.nCells,1);
for i=1:an.nCells
  sisters = find(an.sisterCellIdx == i);
  an.plateWidths(i) = nanmean(nanmax(xCoords(:,sisters)) - ...
                              nanmin(xCoords(:,sisters)));
  
  % Rescale xCoords to plateWidth.
  xCoords(:,sisters) = xCoords(:,sisters) / an.plateWidths(i);
  xCoords1(:,sisters) = xCoords1(:,sisters) / an.plateWidths(i);
  xCoords2(:,sisters) = xCoords2(:,sisters) / an.plateWidths(i);
end

% Compute mean normal shift between pair centres.
normalShifts.sisters.pair.dx = nanmean(...
  xCoords(:,an.pairIdx.sisters.pair(:,1)) - ...
  xCoords(:,an.pairIdx.sisters.pair(:,2)));

% Compute mean normal shift between individual sisters.
xCoordsInd = [xCoords1 xCoords2];
normalShifts.sisters.ind.dx = nanmean(...
  xCoordsInd(:,an.pairIdx.sisters.ind(:,5)) - ...
  xCoordsInd(:,an.pairIdx.sisters.ind(:,6)));

% Store result.
an.normalShifts = normalShifts;

% Record stage.
an.stages = union(an.stages,'normalshifts');

% Unalias analysis.
analysis = an;

% Save analysis mat.
cuplSaveMat(analysis);
