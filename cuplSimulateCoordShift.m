function sisterList=cuplSimulateCoordShift(outfile)
%CUPLSIMULATECOORDSHIT  Simulates unstable coordinate system
%
%   SISTERLIST = CUPLSIMULATECOORDSHIFT Simulates unstable coordinate system and
%   generates fake sisterList.
%
%   CUPLSIMULATECOORDSHIFT(OUTFILE) Saves sisterList in specified mat-file
%   OUTFILE.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

if nargin<1
    outfile=[];
end

% Get parameters.
defaultParams = {'2.5e-4','20','1','3','41','7.5','r','x','0.1'};
responses = inputdlg({'Diffusion coeff. (um^2/s)',...
                      'Number of pairs',...
                      'Pair separation (um)',...
                      'Metaphase plate radius (um)',...
                      'Number of frames',...
                      'Frame interval (sec)',...
                      'Rotation or translation (R/T)',...
                      'Axis (X,Y,Z)',...
                      'Rotation rate (degrees/frame)'},...
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
rotation = lower(responses{7})=='r';
coordAxis = lower(responses{8});
rotationRate = str2double(responses{9});

step = sqrt(2*D*frameInterval);
maxTheta = (rotationRate/180)*pi; % Convert to radians.

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
    % Move frame.
    if rotation
        theta = maxTheta*(2*rand(1,1)-1); % Uniform random theta.
        % Rotate about x-axis.
        pos = permute(coords1(i-1,:,:),[3 2 1]); % Make columns.
        switch coordAxis
          case 'x'
            rot = [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];
          case 'y'
            rot = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
          case 'z'
            rot = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
        end
        pos = pos*rot;
        % Restore shape.
        coords1(i,:,:) = ipermute(pos,[3 2 1]);
    else
        move = permute(step*randn(1,3), [3 2 1]); % FIXME 
        coords1(i,:,:) = coords1(i-1,:,:) + move;
    end
    
    if D>0
        % Move all diffusively.
        moves = step*randn(n,3);
        coords1(i,:,:) = coords1(i,:,:) + permute(moves,[3 2 1]);
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
