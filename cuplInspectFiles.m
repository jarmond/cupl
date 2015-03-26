function analysis=cuplInspectFiles(analysis)
%CUPLINSPECTFILES  Shows key plots to allow user to exclude poor cells
%
%   ANALYSIS = CUPLINSPECTFILES(ANALYSIS) Shows key plots characterising
%   cells to allow user to choose to exclude poor cells. Returns ANALYSIS
%   structure with rejected cells noted.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    error('No analysis struct supplied.');
end

% Alias analysis.
an = analysis;

% Allocate and initialise storage.
an.inspectionAcceptedCells = logical(zeros(an.nLoadedCells,1));

for i=1:an.nLoadedCells
    % Create figure.
    h = figure(1);
    set(h,'dockcontrols','off','menubar','none','name',...
           ['Inspect cell ' num2str(i)],'outerposition',[0 100 800 600]);
    clf;

    figm = 2;
    fign = 2;
    % Indexes of accepted sisters in this cell.
    %idx = indexOfAccepted(an,i);
    idx = find(an.sisterCellIdx == i);

    % Plate projection - x-axis
    subplot(figm,fign,1);
    drawPlate(idx,2,3);
    title('Projection from x-axis');

    % Plate projection - y-axis
    subplot(figm,fign,2);
    drawPlate(idx,3,1);
    title('Projection from y-axis');

    % Autocorrelations
    subplot(figm,fign,3);

    % Loop over sisters.
    numLags = floor(an.maxTrackLength/2);
    autocorrs = nan(numLags+1,length(idx));
    for j=1:length(idx);
      cols = indexToCols(idx(j),1); % x column

      c1 = an.sisterCoords1(:,cols); % Sister 1
      c2 = an.sisterCoords2(:,cols); % Sister 2

      % Compute change in sister centre position.
      delX = diff(mean([c1 c2],2));

      % Compute autocorrelation.
      autocorrs(:,j) = autocorrelation(delX,numLags);
    end
    % Average autocorrelation.
    autocorrs = nanmean(autocorrs,2);
    t = an.time(1:length(autocorrs));
    plot(t,autocorrs);
    title('Autocorrelation, dx');

    reply = input('Include cell? [Y/N/Q]: ','s');
    reply = lower(reply(1));
    switch reply
      case 'n'
        an.inspectionAcceptedCells(i) = 0;
      case 'q'
        close(h);
        error('Cell inspection cancelled.');
      case 'y'
        an.inspectionAcceptedCells(i) = 1;
      otherwise
        warning(['Unknown response ' reply ': assuming include.']);
    end

end


% Make note of inspection.
an.stages = union(an.stages,'inspected');

% Unalias analysis.
analysis = an;

% Save analysis mat.
cuplSaveMat(analysis);



%% NESTED FUNCTIONS

function drawPlate(idx,x,y)
% Draws plate projection using given x and y indices into current figure.
    hold on;
    % Loop over pairs.
    for j=1:length(idx)
      cols = indexToCols(idx(j),[x y]); % x index column

      c1 = an.sisterCoords1(:,cols); % Sister 1
      c2 = an.sisterCoords2(:,cols); % Sister 2

      plot(c1(:,1),c1(:,2),'-b');
      plot(c2(:,1),c2(:,2),'-g');
    end
    hold off;
end


end
