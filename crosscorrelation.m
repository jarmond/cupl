function c=crosscorrelation(x,y,maxLags)
%CROSSCORRELATION  Calculate crosscorrelation between timeseries x and y.
%
%   C = CROSSCORRELATION(X,MAXLAGS) Calculates crosscorrelation C between
%   timeseries x and y, at lags of [-MAXLAGS,MAXLAGS].
%
%   X, Y are timeseries as a vector, or multiple timeseries as a matrix of
%   columns, and should have same dimensions.
%
%   MAXLAGS Optional, specify how many lags to calculate. Defaults to N/2,
%           where N is number of rows of X.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if ~all(size(x) == size(y))
  error('Size of X and Y must be same');
end
  
if size(x,1) == 1
  % Row vectors.
  x = x';
  y = y';
end

[n,m] = size(x);
if nargin < 3
  maxLags = floor(n/2);
end

% Means and std devs.
mx = nanmean(x);
my = nanmean(y);
sx = nanstd(x,1);
sy = nanstd(y,1);

% Crosscorrelate each column.
c = zeros(2*maxLags+1,m);

% Backward lags.
i = 1;
for lag=maxLags:-1:1
  yl = y(1:n-lag,:);
  xl = x(lag+1:n,:);
  vec = (xl-repmat(mx,n-lag,1)).*(yl-repmat(my,n-lag,1));
  c(i,:) = nanmean(vec)./(sx.*sy);
  i = i+1;
end

% Forward lags.
for lag=0:maxLags
  xl = x(1:n-lag,:);
  yl = y(lag+1:n,:);
  vec = (xl-repmat(mx,n-lag,1)).*(yl-repmat(my,n-lag,1));
  c(i,:) = nanmean(vec)./(sx.*sy);
  i = i+1;
end

