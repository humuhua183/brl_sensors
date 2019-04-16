root = '/media/hzg/hzg_muhua/3D_Data/rightcode';
subdir=dir(root);
subdir=subdir(3:end);
for i=1:length(subdir)
    fprintf(['%.2f%% %s\n'],100*i/length(subdir),subdir(i).name);
    brl3D(i).name=subdir(i).name;
    subpath=[root '/' subdir(i).name];
    shapedir=dir([subpath '/*.wrl']);
    landdir=dir([subpath '/*.land']);
    bmpdir=dir([subpath '/*.bmp']);
    if length(landdir)==0
        landdir=dir([subpath '/*.txt']);
    end
    if length(landdir)==1
        cropped_land=[subpath '/' landdir(1).name];
    end
    if length(shapedir(1).name)>length(shapedir(2).name)
%         raw_shape=[subpath '/' shapedir(1).name];
        cropped_shape=[subpath '/' shapedir(2).name];
    else
%         raw_shape=[subpath '/' shapedir(2).name];
        cropped_shape=[subpath '/' shapedir(1).name];
    end
    if length(landdir)==2
        if length(landdir(1).name)>length(landdir(2).name)
            cropped_land=[subpath '/' landdir(2).name];
        else
            cropped_land=[subpath '/' landdir(1).name];
        end
    end
    cropped_bmp=[subpath '/' bmpdir(1).name];
%     [raw_coord,raw_face]=read_wrl(raw_shape);
%     raw_coord=raw_coord';
%     raw_face=raw_face';
%     brl3D(i).raw_coord=raw_coord;
%     brl3D(i).raw_coordindex=raw_face;
    mesh=read_brl_VRML(cropped_shape,cropped_bmp);
    brl3D(i).coord=mesh.VV;
    brl3D(i).coordIndex=mesh.FF;
    brl3D(i).texCoord=mesh.VT;
    brl3D(i).texCoordIndex=mesh.TF;
%     fid_raw=fopen(raw_land);
%     raw_lm3=textscan(fid_raw,'%d %f %f %f');
%     fclose(fid_raw);
    fid_cropped=fopen(cropped_land);
    if strcmp(cropped_land(end),'t')
        cropped_lm3=textscan(fid_cropped,'%d %f %f %f','delimiter',',');
    else
        cropped_lm3=textscan(fid_cropped,'%d %f %f %f');
    end
    fclose(fid_cropped);
%     lm3_raw(:,1)=raw_lm3{1,2};
%     lm3_raw(:,2)=raw_lm3{1,3};
%     lm3_raw(:,3)=raw_lm3{1,4};
%     brl3D(i).raw_lm3=lm3_raw;
    lm3_crop(:,1)=cropped_lm3{1,2};
    lm3_crop(:,2)=cropped_lm3{1,3};
    lm3_crop(:,3)=cropped_lm3{1,4};
    brl3D(i).cropped_lm3=lm3_crop;
end
