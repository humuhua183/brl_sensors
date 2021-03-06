
function [vis] = computer_visible(shape, face, proj_T)
% T = ones(size(shape,1),4);
% T(:,1:3) = shape; 
% T = T * yaw_matrix(bita);
% shape = T(:,1:3);
[normal, normalf] = compute_normal(shape.', face.');

m1 = proj_T(1,1:3);  norm_m1 = norm(m1);
m2 = proj_T(2,1:3);  norm_m2 = norm(m2);
temp = cross(m1/norm_m1,m2/norm_m2);

vis = -normal' * temp';
% vis(find(vis<=0))=0;

% pcshow(shape);
% vis(find(vis>0))=1;
end

function T = yaw_matrix(bita)
   T = [cos(bita) 0 sin(bita) 0;0 1 0 0;-sin(bita) 0 cos(bita) 0;0 0 0 1];
end

function [normal,normalf] = compute_normal(vertex,face)

% compute_normal - compute the normal of a triangulation
%
%   [normal,normalf] = compute_normal(vertex,face);
%
%   normal(i,:) is the normal at vertex i.
%   normalf(j,:) is the normal at face j.
%
%   Copyright (c) 2004 Gabriel Peyr?

% [vertex,face] = check_face_vertex(vertex,face);

nface = size(face,2);
nvert = size(vertex,2);
normal = zeros(3, nvert);

% unit normals to the faces
normalf = crossp( vertex(:,face(2,:))-vertex(:,face(1,:)), ...
    vertex(:,face(3,:))-vertex(:,face(1,:)) );
d = sqrt( sum(normalf.^2,1) ); d(d<eps)=1;
normalf = normalf ./ repmat( d, 3,1 );

% unit normal to the vertex
normal = zeros(3,nvert);
for i=1:nface
    f = face(:,i);
    for j=1:3
        normal(:,f(j)) = normal(:,f(j)) + normalf(:,i);
    end
end
% normalize
d = sqrt( sum(normal.^2,1) ); d(d<eps)=1;
normal = normal ./ repmat( d, 3,1 );

% enforce that the normal are outward
v = vertex - repmat(mean(vertex,1), 3,1);
s = sum( v.*normal, 2 );
if sum(s>0)<sum(s<0)
    % flip
    normal = -normal;
    normalf = -normalf;
end
end


function z = crossp(x,y)
% x and y are (m,3) dimensional
z = x;
z(1,:) = x(2,:).*y(3,:) - x(3,:).*y(2,:);
z(2,:) = x(3,:).*y(1,:) - x(1,:).*y(3,:);
z(3,:) = x(1,:).*y(2,:) - x(2,:).*y(1,:);
end
