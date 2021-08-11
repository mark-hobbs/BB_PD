function [checkcheck] = determineintersection(A, B, C, D, nodei, nodej)
% determineintersection - determine if a bond intersects with a rectangle
% in 3D space
%
% Syntax: [] = determineintersection()
%
% Inputs:
%   rectangle   - p1, p2, p3, p4 are the four corners of the rectange
%   nodei       - start point of a bond
%   nodej       - end point of a bond
%
% Outputs:
%   intersection - true / false the bond intersects with the defined
%                  rectangle
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University
% May 2020

% ---------------------------- BEGIN CODE ---------------------------------

% https://stackoverflow.com/questions/46481111/how-to-find-intersection-point-of-a-line-in-a-plane-in-3d-space-using-matlab


% A = [0 0 0.525];
% B = [0 0.01 0.525];
% C = [0.01 0.01 0.525];
% D = [0.01 0 0.525];
% nodei = [0.005 0.005 0.55];
% nodej = [0.005 0.005 0.525];

% %    x  y  z
A = [0 0 0];
B = [0 0 1];
C = [0.5 1 1];
D = [0.5 1 0];
nodei = [0.5 0.5 1.5];
nodej = [-0.5 0.5 1.5];


bond = [nodei; nodej];

plot3( [A(1) B(1) C(1) D(1) A(1)], [A(2) B(2) C(2) D(2) A(2)], [A(3) B(3) C(3) D(3) A(3)] )
hold on
xlabel('x')
ylabel('y')
zlabel('Z')
axis equal
plot3(bond(:,1), bond(:,2), bond(:,3))

AB = B - A;
AC = C - A;
AD = D - A;
n = cross(AB,AD)/sqrt(dot(cross(AB,AD),cross(AB,AD)));
[I,check] = plane_line_intersect(n,A,nodei,nodej);

% AI = I - A;

% check1 = dot(A,AB);
% check2 = dot(I,AB);
% check3 = dot(B,AB);
% check4 = dot(A,AD);
% check5 = dot(I,AD);
% check6 = dot(D,AD);

checkcheck = 0;

% Check if a point is within a rectangle on a plane in 3D space
% https://math.stackexchange.com/questions/476608/how-to-check-if-point-is-within-a-rectangle-on-a-plane-in-3d-space

if check == 1 % The bond intersects the infinite plane
        
    if ((dot(A,AB) <= dot(I,AB)) && (dot(I,AB) <= dot(B,AB))) && ((dot(A,AD) <= dot(I,AD)) && (dot(I,AD) <= dot(D,AD))) % The bond intersects a segment of the plane

        checkcheck = 1;

    end
end




% ----------------------------- END CODE ----------------------------------
end

function [I,check] = plane_line_intersect(n,V0,P0,P1)
% plane_line_intersect computes the intersection of a plane and a segment(or
% a straight line)
% Inputs: 
%       n: normal vector of the Plane 
%       V0: any point that belongs to the Plane 
%       P0: end point 1 of the segment P0P1
%       P1:  end point 2 of the segment P0P1
%
% Outputs:
%      I    is the point of interection 
%     Check is an indicator:
%      0 => disjoint (no intersection)
%      1 => the plane intersects P0P1 in the unique point I
%      2 => the segment lies in the plane
%      3 => the intersection lies outside the segment P0P1
%
% Example:
% Determine the intersection of following the plane x+y+z+3=0 with the segment P0P1:
% The plane is represented by the normal vector n=[1 1 1]
% and an arbitrary point that lies on the plane, ex: V0=[1 1 -5]
% The segment is represented by the following two points
% P0=[-5 1 -1]
% P1=[1 2 3]   
% [I,check]=plane_line_intersect([1 1 1],[1 1 -5],[-5 1 -1],[1 2 3]);
% This function is written by :
%                             Nassim Khaled
%                             Wayne State University
%                             Research Assistant and Phd candidate
% If you have any comments or face any problems, please feel free to leave
% your comments and I will try to reply to you as fast as possible.

I = [0 0 0];
u = P1 - P0;
w = P0 - V0;
D = dot(n,u);
N = - dot(n,w);
check = 0;

if abs(D) < 10^-7       % The segment is parallel to plane
    if N == 0           % The segment lies in plane
        check = 2;
        return
    else
        check = 0;      % no intersection
        return
    end
end

% Compute the intersection parameter
sI = N / D;
I = P0 + (sI .* u);
if (sI < 0 || sI > 1)
    check = 3;         % The intersection point lies outside the segment, so there is no intersection
else
    check = 1;
end

end
