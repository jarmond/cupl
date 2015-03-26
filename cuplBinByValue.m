function binned=cuplBinByValue(x,y,fields,numBins,range)
% CUPLBINBYVALUE Bin data y by corresponding x value
%
%   BINNED = CUPLBINBYVALUE(X,Y,FIELDS,NUMBINS,MAXX) Bin paired data in y by
%   corresponding x value. X and Y should be structs with fields as described in
%   string cell array FIELDS, each of which is a column vector. Y may also be
%   a matrix, for which binning is performed independently on each column.
%
%   BINNED is a struct with the same fields as X and Y, each of which is a
%   struct containing the following fields:
%       .bins    Data points in each bin as cell array
%       .edges   Right bin edges
%       .centres Bin centres
%       .m       Mean of each bin
%       .s       Standard deviation of each bin
%       .e       Standard error of the mean of each bin
%
%   RANGE Optional, force range of bin centres to be RANGE

if nargin<4
  numBins = 10;
end

if nargin<5
  % Use range of X across all fields.
  maxX = max(cellfun(@(f) max(x.(f)), fields));
  minX = min(cellfun(@(f) min(x.(f)), fields));
  range = [minX, maxX];
end

% Loop over each pairing mode.
for j=1:length(fields)
  field = fields{j};
  xj = x.(field);
  yj = y.(field);
  if size(xj,1) ~= size(yj,1)
    error('X and Y must have same number of rows');
  end
  
  % Loop of columns of Y.
  nCols = size(yj,2);
  binned.(field).m = zeros(numBins,nCols);
  binned.(field).s = zeros(numBins,nCols);
  binned.(field).e = zeros(numBins,nCols);
  for k=1:nCols
    [bins,edges,centres,m,sd,se] = binData(xj,yj(:,k),numBins,range);

    binned.(field).m(:,k) = m;
    binned.(field).s(:,k) = sd;
    binned.(field).e(:,k) = se;
  end
  
  % Same for all columns
  binned.(field).bins = bins;
  binned.(field).edges = edges;
  binned.(field).centres = centres;
end
