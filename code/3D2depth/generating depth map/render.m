save_root = '/home/liuhan/Desktop/brl_dense_depth/';
for ID = 1:124
    T = shape{ID}(lm_index1,:);
    S = zeros(5,3);
    S(1,:) = (T(37,:) + T(40,:))/2;
    S(2,:) = (T(43,:) + T(46,:))/2;
    S(3,:) = T(31,:);
    S(4,:) = T(49,:);
    S(5,:) = T(55,:);
    shape_T = ones(24223,4);
    shape_T(:,1:3) = shape{ID};
    for n = 3:12
        bita = pi/n;      
        yaw_matrix = [cos(bita) 0 sin(bita) 0;0 1 0 0;-sin(bita) 0 cos(bita) 0;0 0 0 1];
        new_shape = shape_T * yaw_matrix';
        proj_T = [1,0,0,320; 0,-1,0,270];
        %proj_T(3,1:3) = cross(proj_T(1,1:3),proj_T(2,1:3));
        %new_shape = shape{ID}*proj_T(1:3,1:3)';
        vis = computer_visible(new_shape(:,1:3), mean_face, proj_T);
        proj_land = new_shape * proj_T';
        M = zeros(5,2);
        M(1,:) = (proj_land(lm_index1(37),:)+proj_land(lm_index1(40),:))/2;
        M(2,:) = (proj_land(lm_index1(43),:)+proj_land(lm_index1(46),:))/2;
        M(3,:) = proj_land(lm_index1(31),:);
        M(4,:) = proj_land(lm_index1(49),:);
        M(5,:) = proj_land(lm_index1(55),:);
        depth_map = ZBuffer(new_shape(:,1:3),proj_land,mean_face,vis);
        min_z = min(min(depth_map));
        for i = 1:480
            for j = 1:640
                if depth_map(i,j)==0
                    continue;
                else
                    depth_map(i,j) = depth_map(i,j) - min_z;
                end
            end
        end
        %imshow(depth_map,[]);
        max_num = max(max(depth_map));
        depth_map = 1 - depth_map/max_num;
        if floor(ID/10)==0
            people_name = ['00' num2str(ID)];
        elseif floor(ID/10)>0 && floor(ID/10)<10
            people_name = ['0' num2str(ID)];
        else
            people_name = num2str(ID);
        end
        if ~exist([save_root people_name],'dir')
            mkdir([save_root people_name]);
        end
        if ~exist([save_root people_name],'dir')
            mkdir([save_root people_name]);
        end
        if ~exist([save_root people_name],'dir')
            mkdir([save_root people_name]);
        end
        if n<10
            file_name = ['0' num2str(n)];
        else
            file_name = num2str(n);
        end
        full_name = [save_root people_name filesep people_name '_' file_name];
        imwrite(depth_map, [full_name '.jpg']);
        fid = fopen([full_name '.txt'],'w');
        fprintf(fid,'%f;',M);
        fclose(fid);
    end
end