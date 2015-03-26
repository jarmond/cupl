function cuplTtestCrossByDist(file1,file2,outfile)
%CUPLTTESTCROSSBYDIST Compare two cross by dist analyses by t-test per bin.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    [filename,pathname] = uigetfile('*.mat','Select first analysis .mat');
    file1=fullfile(pathname,filename);
end
a1=load(file1);

if nargin<2
    [filename,pathname] = uigetfile('*.mat','Select second analysis .mat');
    file2=fullfile(pathname,filename);
end
a2=load(file2);

if nargin<3
    [filename,pathname] = uiputfile('*.csv','Choose name to save as');
    outfile=fullfile(pathname,filename);
end

fid=fopen(outfile,'w+t');

n = size(a1.analysis.corrByDist.n_x,1);
for i=1:n
    % Calculate t-statistics (for two unequal size samples, equal variance).
    % (mu1 - mu2)/(S * sqrt(1/n1 + 1/n2))
    %     where S = sqrt(((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-1))
    
    mu1 = a1.analysis.corrByDist.c_x(i);
    mu2 = a2.analysis.corrByDist.c_x(i);
    
    sd1 = a1.analysis.corrByDist.c_sd_x(i);
    sd2 = a2.analysis.corrByDist.c_sd_x(i);
    
    % Didn't originally store bin counts so get n from relationship between
    % sd and se.
    se1 = a1.analysis.corrByDist.c_se_x(i);
    se2 = a2.analysis.corrByDist.c_se_x(i);
    n1 = (sd1/se1)^2;
    n2 = (sd2/se2)^2;
       
    df = n1+n2-2;
    S = sqrt(((n1-1)*sd1^2 + (n2-1)*sd2^2)/df);
    T = (mu1 - mu2)/(S * sqrt(1/n1 + 1/n2)); % t-statistic
    
    p = 2*tcdf(-abs(T),df); % two-tailed.
    c = a1.analysis.corrByDist.binCentres(i);
    fprintf('Bin: %.2f mu1-mu2: %.2f t-statistic: %.2f p-value: %.3g\n',c, ...
            abs(mu1-mu2),T,p);
    fprintf(fid,'%f %f %g\n',c,T,p);
end

fclose(fid);