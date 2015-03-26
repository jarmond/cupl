function cuplDrawPlate(analysis,cellIdx)
%CUPLDRAWPLATE  Draws a metaphase plate projection for each cell.
%
%   CUPLDRAWPLATE(ANALYSIS) Draws a metaphase plate projection for each
%   cell.
%
%   CUPLDRAWPLATE(ANALYSIS,CELLIDX) Draws only the cell numbers indexed in
%   vector CELLIDX.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

% Alias analysis.
an = analysis;

% Create figure.
figure;
xlabel('um');
ylabel('um');
cols = indexToCols(find(an.sisterCellIdx == cellIdx),[1 2]);
plot(an.sisterCoords1(:,cols(1:2:end)),an.sisterCoords1(:,cols(2:2:end)),'-b',...
     an.sisterCoords2(:,cols(1:2:end)),an.sisterCoords2(:,cols(2:2:end)),'-g');
