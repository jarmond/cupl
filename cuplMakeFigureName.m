function name=cuplMakeFigureName(analysis,title)
% CUPLMAKEFIGURENAME Generate a prefixed figure filename

if nargin<1
    error('No analysis struct supplied.');
end

name = fullfile(analysis.outputDirectory,...
                [strtok(analysis.outputFilename,'.') '-' title '.pdf']);