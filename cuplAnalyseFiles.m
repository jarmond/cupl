function analysis=cuplAnalyseFiles(jobs,varargin)
% CUPLANALYSEFILES  Run analyses on selected files
%
%   ANALYSIS = CUPLANALYSEFILES(JOBS,VARARGIN)
%   Runs analysis on selected files.
%
%   JOBS Optional, default all jobs. Runs only the specified analysis jobs
%   on selected files, where JOBS is a vector of integers. The integer codes
%   for jobs are:
%      -3: Force re-preprocessing
%      -2: Load data only
%      -1: Draw plots
%       0: User inspection of cells
%       1: Autocorrelations
%       2: Cross-correlations
%       3: Distances
%       4: Speeds
%       5: Mean squared displacement
%       6: Normal shifts
%       7: Monopolar cross-correlations
%
%   VARARGIN Optional string/value pairs:
%
%   'analysis' Updates the already existing ANALYSIS structure. May
%   pass [].
%
%   'drawPlots' Set to 0 to disable plot drawing.
%
%   'dataDir' Specify the directory to search for data rather than
%   use GUI.
%
%   'useAllFiles' If 1, don't ask which files to analyse - take 'em
%   all.
%
%   'outfile' Specify the file to save analysis in rather than use GUI.
%
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

% Defaults.
if nargin<1 || isempty(jobs)
  jobs = 1:5;
end

opts.analysis = [];
opts.dataDir = [];
opts.useAllFiles = 0;
opts.outfile = [];
opts.drawPlots = 1;
opts = processOptions(opts,varargin{:});

analysis = opts.analysis;

if isempty(analysis)
  % Select files to analyse.
  analysis = cuplSelectFiles(opts.dataDir,opts.useAllFiles);
  if isempty(analysis)
    error('Files not selected');
  end

  analysis = cuplSelectOutfile(analysis,opts.outfile);
end

% Record CupL version.
analysis.version = cuplVersion();

% Make sure we always have a stages to play with.
if ~isfield(analysis,'stages')
  analysis.stages = {};
end

if ~isfield(analysis,'options')
  % Get parameters.
  analysis = cuplAskParameters(analysis);
else
  disp('Using existing options field.');
end

if ismember(6,jobs) && ~isfield(analysis,'plotOptions')
    analysis = cuplAskPlotParameters(analysis);
end

if ~ismember('loaded',analysis.stages)
  cuplPrintStatus(['Loading data from ' ...
                   num2str(length(analysis.dataFilenames)) ' files']);
  analysis = cuplLoadData(analysis);
  if ismember(-2,jobs)
    cuplPrintStatus('Stopping due to load-only mode.');
    return;
  end
end

if ismember('inspected',analysis.stages)
  disp('Cells already user inspected or inspection declined.');
end

% Job 0: Inspect cells
if ismember(0,jobs) || ~ismember('inspected',analysis.stages)
  cuplPrintStatus('Beginning user cell inspection.');
  analysis = cuplInspectFiles(analysis);
  cuplPrintStatus('Finished user cell inspection.');
else
  % Ensure that all cells get selected.
  if ~isfield(analysis,'inspectionAcceptedCells')
    analysis.inspectionAcceptedCells = logical(ones(analysis.nLoadedCells,1));
  end
end

cuplPrintStatus(['Analysis started for jobs: ' num2str(jobs)]);

if ismember(-3,jobs) || ~ismember('preprocess',analysis.stages)
  % Preprocess files (count nans, eliminate cells with too few tracks, etc...)
  analysis = cuplPreprocess(analysis);
else
  disp('Using existing preprocessing data.');
end


%% Run analyses.

if ismember(1,jobs)
  cuplPrintStatus('Computing autocorrelation...');
  analysis = cuplAutocorrelation(analysis);
end

if ismember(2,jobs)
  cuplPrintStatus('Computing crosscorrelation...');
  analysis = cuplCrosscorrelation(analysis);
end

if ismember(3,jobs)
  cuplPrintStatus('Computing distances...');
  analysis = cuplDistances(analysis);
end

if ismember(4,jobs)
  cuplPrintStatus('Computing speeds...');
  analysis = cuplSpeeds(analysis);
end

if ismember(5,jobs)
  cuplPrintStatus('Computing mean squared displacement...');
  analysis = cuplMsd(analysis);
end

if ismember(6,jobs)
  cuplPrintStatus('Computing normal shifts...');
  analysis = cuplNormalShifts(analysis);
end

if ismember(7,jobs)
  cuplPrintStatus('Computing monopolar crosscorrelation...');
  analysis = cuplMonopolar(analysis);
end

cuplPrintStatus('Analysis finished.');

%% Post-analysis

cuplPrintStatus('Post-analysis started...');

if all(ismember({'crosscorrs','distances'},analysis.stages))
  cuplPrintStatus('Computing correlation by distance...');
  analysis = cuplCrossByDist(analysis);

  cuplPrintStatus('Computing correlation for nearest and furthest...');
  analysis = cuplNearFar(analysis);
end

if ismember('monopole',analysis.stages)
  cuplPrintStatus('Computing monopolar correlation by distance...');
  analysis = cuplMonopolarByDist(analysis);
end

cuplPrintStatus('Post-analysis finished.');

%% Plotting

if ismember(-1,jobs) || opts.drawPlots
  plots = cuplAskPlots(analysis);
  cuplPrintStatus('Drawing plots...');
  analysis = cuplDrawPlots(analysis,plots);
end


%% Summary statistics

fprintf('\nSummary statistics:-\n\n');
fprintf('Total cells: %d\n',analysis.nLoadedCells);
fprintf('Accepted cells: %d\n',analysis.nCells);
fprintf('Total sisters: %d\n',analysis.nLoadedSisters);
fprintf('Accepted sisters: %d\n',analysis.nSisters);

% Dump statistics to CSV.

% Strip fields.
if ~analysis.options.keepAllData
  analysis = cuplStripData(analysis);
end
