function plotcube(varargin)
% PLOTCUBE - Display a 3D-cube in the current axes
%
%   PLOTCUBE(EDGES,ORIGIN,ALPHA,COLOR,LINEWIDTH) displays a 3D-cube in the current axes
%   with the following properties:
%   * EDGES     : 3-elements vector that defines the length of cube edges
%   * ORIGIN    : 3-elements vector that defines the start point of the cube
%   * ALPHA     : scalar that defines the transparency of the cube faces (from 0 to 1)
%   * COLOR     : 3-elements vector that defines the faces color of the cube
%   * LINEWIDTH : scalar that defines the thickess of polygon edges
%
% Example:
%   >> plotcube([5 5 5],[ 2  2  2],.8,[1 0 0],1);
%   >> plotcube([5 5 5],[10 10 10],.8,[0 1 0],2);
%   >> plotcube([5 5 5],[20 20 20],.8,[0 0 1]),3;

% Default input arguments
inArgs = { ...
  [10 56 100] , ... % Default edge sizes (x,y and z)
  [10 10  10] , ... % Default coordinates of the origin point of the cube
  .7          , ... % Default alpha value for the cube's faces
  [1 0 0]     , ... % Default Color for the cube
  1             ... % Default line width
  };

% Replace default input arguments by input values
inArgs(1:nargin) = varargin;

% Create all variables
[edges,origin,alpha,clr,linewidth] = deal(inArgs{:});

% ---------------------------------
%   XYZ{1}  |  XYZ{2}  |  XYZ{3} |
% ---------------------------------
XYZ = { ...
  [0 0 0 0]  [0 0 1 1]  [0 1 1 0] ; ... % 1
  [1 1 1 1]  [0 0 1 1]  [0 1 1 0] ; ... % 2
  [0 1 1 0]  [0 0 0 0]  [0 0 1 1] ; ... % 3
  [0 1 1 0]  [1 1 1 1]  [0 0 1 1] ; ... % 4
  [0 1 1 0]  [0 0 1 1]  [0 0 0 0] ; ... % 5
  [0 1 1 0]  [0 0 1 1]  [1 1 1 1]   ... % 6
  };

XYZ = mat2cell(...
  cellfun( @(x,y,z) x*y+z , ...
    XYZ , ...
    repmat(mat2cell(edges,1,[1 1 1]),6,1) , ...     % Cube has 6 faces
    repmat(mat2cell(origin,1,[1 1 1]),6,1) , ...
    'UniformOutput',false), ...
    6,[1 1 1]);

cellfun(@patch,XYZ{1},XYZ{2},XYZ{3},... % Apply function to each cell in cell array
  repmat({clr},6,1),...                 % Return an array containing 6x1 copies of {clr}
  repmat({'FaceAlpha'},6,1),... 
  repmat({alpha},6,1),...
  repmat({'LineWidth'},6,1),... 
  repmat({linewidth},6,1)... 
  );

view(3);

end