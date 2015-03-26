function cuplTtestCrossByDistCutoff(file1,file2,cutoff)
%CUPLTTESTCROSSBYDIST Compare two cross by dist analyses by t-test per bin.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1 || isempty(file1)
    [filename,pathname] = uigetfile('*.mat','Select first analysis .mat');
    file1=fullfile(pathname,filename);
end
a1=load(file1);

if nargin<2 || isempty(file2)
    [filename,pathname] = uigetfile('*.mat','Select second analysis .mat');
    file2=fullfile(pathname,filename);
end
a2=load(file2);

lt1 = a1.analysis.distances.sisters.pair.d<cutoff;
gt1 = a1.analysis.distances.sisters.pair.d>=cutoff;
lt2 = a2.analysis.distances.sisters.pair.d<cutoff;
gt2 = a2.analysis.distances.sisters.pair.d>=cutoff;

corr_lt1 = a1.analysis.crosscorrs.sisters.pair.dx(21,lt1);
corr_gt1 = a1.analysis.crosscorrs.sisters.pair.dx(21,gt1);
corr_lt2 = a2.analysis.crosscorrs.sisters.pair.dx(21,lt2);
corr_gt2 = a2.analysis.crosscorrs.sisters.pair.dx(21,gt2);

[~,p_lt] = ttest2(corr_lt1, corr_lt2);
[~,p_gt] = ttest2(corr_gt1, corr_gt2);

mu_lt = abs(mean(corr_lt1) - mean(corr_lt2));
mu_gt = abs(mean(corr_gt1) - mean(corr_gt2));

fprintf('LT: mu_lt-mu_gt: %.2f p-value: %.3g\n',mu_lt,p_lt);
fprintf('GT: mu_lt-mu_gt: %.2f p-value: %.3g\n',mu_gt,p_gt);
