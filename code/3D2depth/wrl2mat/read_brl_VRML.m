%transform 3d wrl file to mat file
function mesh = read_brl_VRML(vrmlName,imageName)
% mesh = readVRMLfile(vrmlFileName)
im = imread(imageName);
%im = imread('F0001_NE00WH_F3D.bmp');

n = 0; % no of data points
m = 0; % no of triangle facets
o = 0;
p = 0;

fid = fopen(vrmlName);
%fid = fopen('F0001_NE00WH_F3D.wrl');
A = '';
zz = 1;
line = fgetl(fid);
while isempty(A) || A(1) == 0.35 || A(1) ==  0.7 || A(1) == 0.7 || A(1) == 0 || A(1) == 0.2
    while  ~strncmp(line,' point [   ',6)
        line = fgetl(fid);
        A = sscanf(line, '%f');
        zz = zz + 1;
        if zz == 40
            return;
        end
    end
    s = regexp(line,' point [','split');
    line=s{2};
    A = sscanf(line, '%f');
end
%line = fgetl(fid);
%line = fgetl(fid);
%A = sscanf(line, '%f')
while length(A) == 3
    n = n + 1;
    data(n,:) = A';
    line = fgetl(fid);
    A = sscanf(line, '%f');
end
while length(A) == 0
    line = fgetl(fid);
    line(find(line==',')) = ' ';
    A = sscanf(line, '%f');
end
while length(A) == 4 || length(A) == 5 || length(A) == 6 || length(A) == 7
    if length(A) == 4
        m = m + 1;
        A(4) = [];
        A = A + 1;
        polygon(m,:) = A';
    elseif length(A) == 5
        m = m + 2;
        A(5) = [];
        A = A + 1;
        polygon(m-1,:) = A(1:3)';
        polygon(m,:) = [A(1) A(3) A(4)]';
    elseif length(A) == 6
        m = m + 3;
        A(6) = [];
        A = A + 1;
        polygon(m-2,:) = A(1:3)';
        polygon(m-1,:) = [A(1) A(3) A(4)]';
        polygon(m,:) = [A(1) A(4) A(5)]';
    elseif length(A) == 7
        m = m + 4;
        A(7) = [];
        A = A + 1;
        polygon(m-3,:) = A(1:3)';
        polygon(m-2,:) = [A(1) A(3) A(4)]';
        polygon(m-1,:) = [A(1) A(4) A(5)]';
        polygon(m,:) = [A(1) A(5) A(6)]';
    end
    
    line = fgetl(fid);
    line(find(line==',')) = ' ';
    A = sscanf(line, '%f');
end

while length(A) == 0
    while  ~strncmp(line,' point [   ',6)
        line = fgetl(fid);
        line(find(line==',')) = ' ';
        A = sscanf(line, '%f');
    end
    s = regexp(line,' point [','split');
    line=s{2};
    A = sscanf(line, '%f');
end

while length(A) == 2
    o = o + 1;
    texcoord(o,:) = A';
    line = fgetl(fid);
    A = sscanf(line, '%f');
end

while length(A) == 0
    line = fgetl(fid);
    line(find(line==',')) = ' ';
    A = sscanf(line, '%f');
end

%
while length(A) == 4 || length(A) == 5 || length(A) == 6|| length(A) == 7
    if length(A) == 4
        p = p + 1;
        A(4) = [];
        A = A + 1;
        texcoord_index(p,:) = A';
    elseif length(A) == 5
        p = p + 2;
        A(5) = [];
        A = A + 1;
        texcoord_index(p-1,:) = A(1:3)';
        texcoord_index(p,:) = [A(1) A(3) A(4)]';
    elseif length(A) == 6
        p = p + 3;
        A(6) = [];
        A = A + 1;
        texcoord_index(p-2,:) = A(1:3)';
        texcoord_index(p-1,:) = [A(1) A(3) A(4)]';
        texcoord_index(p,:) = [A(1) A(4) A(5)]';
    elseif length(A) == 7
        p = p + 4;
        A(7) = [];
        A = A + 1;
        texcoord_index(p-3,:) = A(1:3)';
        texcoord_index(p-2,:) = [A(1) A(3) A(4)]';
        texcoord_index(p-1,:) = [A(1) A(4) A(5)]';
        texcoord_index(p,:) = [A(1) A(5) A(6)]';
    end
    
    line = fgetl(fid);
    line(find(line==',')) = ' ';
    A = sscanf(line, '%f');
end

fclose(fid);

mesh.VV = data;                 %1.coord Coordinate(point) n*3
mesh.FF = polygon;              %2.coordIndex n*3
mesh.TF = texcoord_index;       %4.texCoordIndex(coord_index) n*3
mesh.VT = texcoord;             %3.texCoord TextureCoordinate(texCoord) n*2
mesh.I = im;

