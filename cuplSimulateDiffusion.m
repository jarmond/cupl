function sisterList=cuplSimulateDiffusion(outfile)
%CUPLSIMULATEDIFFUSION  Simulates diffusing kinetochores and saves as sisterLists
%
%   SISTERLIST = CUPLSIMULATEDIFFUSION Simulates diffusing kinetochores and
%   creates sisterList structures.
%
%   CUPLSIMULATEDIFFUSION(OUTFILE) Saves sisterLists in specified mat-file
%   OUTFILE.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    outfile=[];
end

% Get parameters.
defaultParams = {'2.5e-4','20','1','3','41','7.5','0','N'};
responses = inputdlg({'Diffusion coeff. (um^2/s)',...
                      'Number of pairs',...
                      'Pair separation (um)',...
                      'Metaphase plate radius (um)',...
                      'Number of frames',...
                      'Frame interval (sec)',...
                      'Correlation factor (0..1)',...
                      'Distance dependent correlation (Y/N)'},...
                    'Enter analysis parameters',1,defaultParams);
if isempty(responses)
    responses = defaultParams;
end

D = str2double(responses{1});
n = str2double(responses{2});
separation = str2double(responses{3});
radius = str2double(responses{4});
frames = str2double(responses{5});
frameInterval = str2double(responses{6});
corrFactor = str2double(responses{7});
distDep = lower(responses{8})=='y';
step = sqrt(2*D*frameInterval);

if corrFactor>0
    if distDep
        disp('Distance-dependent correlation');
    else
        disp('Distance-independent correlation');
    end
else
    disp('Uncorrelated');
end

% Generate kinetochore starting positions.
coords1 = zeros(frames,3,n);
coords2 = zeros(frames,3,n);
theta = linspace(0,2*pi,n+1);
for i=1:n
    coords1(1,:,i) = [0.5*separation, radius*sin(theta(i)), radius*cos(theta(i))];
    coords2(1,:,i) = [-0.5*separation, radius*sin(theta(i)), radius*cos(theta(i))];
end

% Simulate diffusion of kinetochores, with no breathing.
for i=2:frames
    % Move all diffusively.
    moves = step*randn(n,3);
    
    % Couple movement to kinetochore 1.
    if distDep
        for j=2:n
            % Calculate distance between j and 1.
            dists(j) = norm(coords1(i-1,:,j)-coords1(i-1,:,1),2);
        end
    else
        dists = ones(n,1);
    end

    % Move kinetochore 1.
    coords1(i,:,1) = coords1(i-1,:,1) + moves(1,:);
    
    % Move others.
    for j=2:n
        if distDep
            f = corrFactor*dists(j)/(2*radius);
        else
            f = corrFactor;
        end
        coords1(i,:,j) = coords1(i-1,:,j) + (1-f)*moves(j,:) + f*moves(1,:);
    end
    
    % Rigidly attached sisters.
    coords2(i,2:3,:) = coords1(i,2:3,:);
    coords2(i,1,:) = coords1(i,1,:) - separation;
end

% Create sisterList structures.
for i=1:n
    sisterList(i).coords1 = coords1(:,:,i);
    sisterList(i).coords2 = coords2(:,:,i);
end

% Save sisterList.
if ~isempty(outfile)
    save(outfile,'sisterList');
end
