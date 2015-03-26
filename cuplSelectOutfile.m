function analysis=cuplSelectOutfile(analysis,outfile)
% CUPLSELECTOUTFILE Select mat filename to store analysis in.
%
% Copyright (c) 2013 Jonathan Armond

if nargin<2 || isempty(outfile)
  % File not specified, ask user.
  [filename,pathname] = uiputfile('*.mat','Specify a filename for analysis output',...
                                  analysis.dataDirectory);
  if isequal(filename,0) || isequal(pathname,0)
    error('No analysis filename specified.');
  end
else
  [pathname,filename,ext] = fileparts(outfile);
  filename = [filename ext];
end

analysis.outputDirectory = pathname;
if ~exist(analysis.outputDirectory,'dir')
  mkdir(analysis.outputDirectory);
end

if length(filename)<=4 || ~strcmp(filename(end-3:end),'.mat')
  filename = [filename '.mat'];
end
analysis.outputFilename = filename;

% Check for existing analysis file.
if exist(fullfile(analysis.outputDirectory,analysis.outputFilename),'file')
    choice = questdlg(['Analysis file already exists. Do you want to update or ' ...
                       'replace it?'],'Analysis file exists','Update','Replace',...
                      'Cancel','Cancel');
    switch choice
      case 'Update'
        load(fullfile(analysis.outputDirectory,analysis.outputFilename));
        return
      case 'Cancel'
        error('File selection cancelled.');
    end
end

% Save analysis mat.
cuplSaveMat(analysis);
