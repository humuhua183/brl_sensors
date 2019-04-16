% for i = 1: 124
%     shape = data.shape(:,i);
%     shape = reshape(shape,[24223 3]);
%     T = ones(length(shape(:,1)),4);
%     T(:,1:3) = shape;
%     proj_land = T * f_T';
%     depth_map = ZBuffer(shape,proj_land,data.face);
%     imshow(depth_map, []);
% end
root = '/home/hzg/hzg_data/scu_data/final_scu_data/';
save_root = '/home/hzg/hzg_data/high_scu_data/';
tdpath='/media/hzg/hzg_muhua/data_deal/3D2depth/brl3D3.mat';
% load(tdpath);
brl3D1=brl3D3;
people = dir(root);
people=people(3:end);
for q = 581:674
    fprintf('[%f%% %s] \n',100*q/length(people),people(q).name);
    for i=1:length(brl3D1)
        if strcmp(people(q).name,brl3D1(i).name)
            break;
        end
    end
   light_fold=[root people(q).name];
   lightdir=dir(light_fold);
   for m=3:length(lightdir)
       datalistpath=[light_fold '/' lightdir(m).name '/dataList.mat'];
       load(datalistpath);
        for p = 1:length(final_datalist)
            s = regexp(final_datalist(p).file,'/','split');
            img_name = final_datalist(p).file;
            M=final_datalist(p).facial5point;
            T = brl3D1(i).cropped_lm3;
            S = zeros(5,3);
            S(1,:) = (T(20,:) + T(23,:))/2;
            S(2,:) = (T(26,:) + T(29,:))/2;
            S(3,:) = T(14,:);
            S(4,:) = T(32,:);
            S(5,:) = T(38,:);
            index=knnsearch(brl3D1(i).coord,S);
            shape_T = ones(length(brl3D1(i).coord(:,1)),4);
%             land_T = ones(length(S(:,1)),4);
            shape_T(:,1:3) = brl3D1(i).coord;
%             land_T(:,1:3) = S;
            proj_T = weak_projection(M',S');
            proj_T(3,1:3) = cross(proj_T(1,1:3),proj_T(2,1:3));
            new_shape = brl3D1(i).coord*proj_T(1:3,1:3)';
%             new_shape = brl3D1(i).coord;
            vis = computer_visible(brl3D1(i).coord, brl3D1(i).coordIndex, proj_T);
            proj_shape= shape_T * proj_T';
%             proj_land = land_T * proj_T';
            proj_land=proj_shape(index,:);
            depth_map = ZBuffer(new_shape,proj_shape,brl3D1(i).coordIndex,vis);
            min_z = min(min(depth_map));
            for ii = 1:540
                for j = 1:960
                    if depth_map(ii,j)==0
                        continue;
                    else
                        depth_map(ii,j) = depth_map(ii,j) - min_z;
                    end
                end
            end
            %imshow(depth_map,[]);
            max_num = max(max(depth_map));
            for ii = 1:540
               for j = 1:960
                   if depth_map(ii,j)==0
%                        continue;
                     depth_map(ii,j)=1;
                   else
                     depth_map(ii,j) = depth_map(ii,j)/max_num;
                   end
               end
            end
            if ~exist([save_root people(q).name],'dir')
                mkdir([save_root people(q).name]);
            end
            if ~exist([save_root people(q).name filesep s{2} filesep 'depth' filesep s{4}],'dir')
                mkdir([save_root people(q).name filesep s{2} filesep 'depth' filesep s{4}]);
            end
            imgname=strrep(s{5},'color','depth');
            imgname=strrep(imgname,'_c','_d');
            imgpath=[save_root people(q).name filesep s{2} filesep 'depth' filesep s{4} filesep imgname];
            imwrite(depth_map,imgpath);
            new_datalist(p).file=[people(q).name filesep s{2} filesep 'depth' filesep s{4} filesep imgname];
            new_datalist(p).facial5point=proj_land;
%             original_depth = imread([root people(q).name filesep '01/depth' filesep img_name]);
%             center_point(1) = (pts{1}(11) + pts{1}(13))/2;
%             center_point(2) = (pts{1}(12) + pts{1}(14))/2;
%             rec_length = pts{1}(14) - pts{1}(12);
%             original_crop = imcrop(original_depth,[center_point(1)-rec_length/2 center_point(2)-rec_length/2 rec_length-1 rec_length-1]);
%             original_crop = imresize(original_crop,[128 128]);
%             depth_map_crop = imcrop(depth_map,[center_point(1)-rec_length/2 center_point(2)-rec_length/2 rec_length-1 rec_length-1]);
%             depth_map_crop = imresize(depth_map_crop,[128 128]);
%             imwrite(original_crop,[save_root people(q).name filesep 'low' filesep img_name]);
%             imwrite(depth_map_crop, [save_root people(q).name filesep 'high' filesep img_name]);
            %copyfile(pts_file,[save_root people(q).name filesep 'low' filesep pts_path(p).name]);
        end
        listpath=[save_root people(q).name filesep s{2} filesep 'datalist'];
        save(listpath,'new_datalist');
        clear new_datalist;
    end
end
