function res = face_db_align(face_dir, ffp_dir, ec_mc_y, ec_y, img_size, save_dir,file_filter,output_format,pts_format)

% center of eyes (ec), center of l&r mouth(mc), rotate and resize
% ec_mc_y: y_mc-y_ec, diff of height of ec & mc, to scale the image.
% ec_y: top of ec, to crop the face.
%alignment('L:\CurtinFace\origi\texture','L:\CurtinFace\origi\texture',48,40,128,'L:\CurtinFace\alignedFace','.jpg','jpg','txt');
clck = clock();
% log_fn = sprintf('fa2_%4d%02d%02d%02d%02d%02d.log', [clck(1:5) floor(clck(6))]);
% log_fid = fopen(log_fn, 'w');
%alignment('H:\Beihang\NU','H:\Beihang\NU',48,40,128,'H:\Beihang\TestImage\color\NU','.jpg','jpg','txt')
crop_size = img_size;

% % ssubdir = dir(face_dir);
ssubdir = dir(face_dir);
ssubdir = ssubdir(3:end);
for i=1: length(ssubdir)
    a=ssubdir(i).name;
    hzg=a(end-2:end);
    if(hzg=='txt')
        continue;
    end
   b=a(1:end-4);
   hsubdir=dir(ffp_dir);
   for z=3:length(hsubdir)
       c=hsubdir(z).name;
       d=c(1:end-4);
       e=c(end-2:end);
       if(e=='png')
           continue;
       else
       if(b==d)
           filename=c;
           break;
       else 
           filename='null';
       end
       end
   end
   if(strcmp(filename,'null'))
      continue;
   end
% %     if(b=='png')  huzhenguo注释
% %        continue;
% %    
% %     else

%     if ~ subdir(i).isdir
%         continue;
%     end
 %   fprintf('[%.2f%%] %s\n', 100*i/length(subdir), subdir(i).name);
%  for j=1:4
%      pathstr = [save_dir filesep subdir(i).name];
  pathstr=strcat(save_dir,'\',ssubdir(i).name(1:end-3),'jpg');
%     if exist(pathstr, 'dir')  == 0
%         fprintf('create %s\n', pathstr);
%         mkdir(pathstr);
%     end
    
%     pts_fns = dir([face_dir filesep subdir(i).name '\0' num2str(j) '\*' pts_format]);
%     for k=1: length(pts_fns)
%         img = imread([face_dir filesep subdir(i).name '\0' num2str(j) filesep  pts_fns(k).name(1:end-3) 'bmp']);
% %  img=imread( strcat(face_dir,'\',ssubdir(i).name(1:end-3),'png'));
     img=imread( strcat(face_dir,'\',ssubdir(i).name));
%         ffp_fn = [ffp_dir filesep subdir(i).name '\0' num2str(j) filesep pts_fns(k).name];
% %  ffp_fn=strcat(ffp_dir,'\',ssubdir(i).name);
     ffp_fn=strcat(ffp_dir,'\',filename);
%         if exist(ffp_fn, 'file') == 0
%             img2 = img;
%             fprintf('%s NOT exists.\n', ffp_fn);
%             imgh = size(img,1);
%             imgw = size(img,2);
%             crop_y = floor((imgh - crop_size)/2);
%             crop_x = floor((imgw - crop_size)/2);
%             img_cropped = img(crop_y:crop_y+crop_size-1, crop_x:crop_x+crop_size-1,:);
%             eyec = [1 1];
%             continue;
%             %             fprintf(log_fid, '%s nonexists, cropped center\n', ffp_fn);
%         else
            disp(ffp_fn);
            f5pt = read_5pt(ffp_fn);
            %img=rgb2gray(img);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
%             [img2, eyec, img_cropped, resize_scale] = align(img, f5pt, crop_size, ec_mc_y, ec_y);
%        img_final = imresize(img_cropped, [img_size img_size], 'Method', 'bicubic');
        %%% 这是对于LCNN的对齐   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
%         end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        imgSize     = [112,96];
       coord5point = [30.2946, 51.6963;
               65.5318, 51.5014;
               48.0252, 71.7366;
               33.5493, 92.3655;
               62.7299, 92.2041];
            Tfm =  cp2tform(f5pt, coord5point, 'similarity');
        cropImg = imtransform(img, Tfm, 'XData', [1 imgSize(2)],...
            'YData', [1 imgSize(1)], 'Size', imgSize);
          img_final=cropImg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%这是对sphereface的对齐%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         figure(1);
%         subplot(1,3,1);
%         imshow(img);
%         hold on;
%         plot(f5pt(1:5,1),f5pt(1:5,2),'.g');
% 
%         plot(f5pt(1,1),f5pt(1,2), 'bo');
%         plot(f5pt(2,1),f5pt(2,2), 'bo');
%         hold off;
%         subplot(1,3,2);
%         imshow(img2);
%         %         rectangle('Position', [round(eyec(1)) round(eyec(2)) 10 10]);
%         hold on;
%         plot(eyec(1), eyec(2), 'ro');
%         plot(10,100, 'bx');
%         hold off;
%         subplot(1,3,3);
%         imshow(img_cropped);
%         hei=size(img_cropped,1)/2;
%         wid=size(img_cropped,2)/2;
%         hold on;
%         %         plot(hei,wid,'.g');
%         pause;
%         
        
        
%         img_final = imresize(img_cropped, [img_size img_size], 'Method', 'bicubic');
%                 if size(img_final,3)>1
%                     img_final = rgb2gray(img_final);
%                 end
%          if ~exist(pathstr,'dir')
%              mkdir(pathstr);
%          end
%          if ~exist(strcat(pathstr,'\0',num2str(j)),'dir')
%              mkdir(strcat(pathstr,'\0',num2str(j)));
%          end
%         save_fn = [pathstr '\0' num2str(j) filesep pts_fns(k).name(1:end-3) output_format];
%         imwrite(uint8(double(img_final)/65535*255), pathstr);
        imwrite(img_final, pathstr);
    end
% end
% end
% fclose(log_fid);
end

function res = read_5pt(fn)
% fid = fopen(fn, 'r');
% raw = textscan(fid, '%f;');
% raw=raw{1};
% fclose(fid);
% res(1:5,1)=raw(1:5);
% res(1:5,2)=raw(6:10);

% fid = fopen(fn, 'r');
% raw = textscan(fid, '%f %f');
% raw=raw{1};
% fclose(fid);
% res(1:5,1)=raw(1:5);
% res(1:5,2)=raw(6:10);
% res = zeros(5, 2);
fid = fopen(fn, 'r');
answ = textscan(fid,'%f;%f;%f;%f;%f;%f;%f;%f;%f;%f');
res=zeros(5,2);
for h=1:5
    res(h,1)=answ{h};
    res(h,2)=answ{h+5};
end
% res(:,1) = answ{1,1};
% res(:,2) = answ{1,2};
fclose(fid);

end

function [res, eyec2, cropped, resize_scale] = align(img, f5pt, crop_size, ec_mc_y, ec_y)
f5pt = double(f5pt);
ang_tan = (f5pt(1,2)-f5pt(2,2))/(f5pt(1,1)-f5pt(2,1));
ang = atan(ang_tan) / pi * 180;
img_rot = imrotate(img, ang, 'bicubic');
imgh = size(img,1);
imgw = size(img,2);

% eye center
x = (f5pt(1,1)+f5pt(2,1))/2;
y = (f5pt(1,2)+f5pt(2,2))/2;
% x = ffp(1);
% y = ffp(2);

ang = -ang/180*pi;
%{
x0 = x - imgw/2;
y0 = y - imgh/2;
xx = x0*cos(ang) - y0*sin(ang) + size(img_rot,2)/2;
yy = x0*sin(ang) + y0*cos(ang) + size(img_rot,1)/2;
%}
[xx, yy] = transform(x, y, ang, size(img), size(img_rot));
eyec = round([xx yy]);
x = (f5pt(4,1)+f5pt(5,1))/2;
y = (f5pt(4,2)+f5pt(5,2))/2;
[xx, yy] = transform(x, y, ang, size(img), size(img_rot));
mouthc = round([xx yy]);

resize_scale = ec_mc_y/(mouthc(2)-eyec(2));

img_resize = imresize(img_rot, resize_scale);

res = img_resize;
%hujun why?
eyec2 = (eyec - [size(img_rot,2)/2 size(img_rot,1)/2]) * resize_scale + [size(img_resize,2)/2 size(img_resize,1)/2];
eyec2 = round(eyec2);
img_crop = zeros(crop_size, crop_size, size(img_rot,3));
% crop_y = eyec2(2) -floor(crop_size*1/3);
crop_y = eyec2(2) - ec_y;
crop_y_end = crop_y + crop_size - 1;
crop_x = eyec2(1)-floor(crop_size/2);
crop_x_end = crop_x + crop_size - 1;

box = guard([crop_x crop_x_end crop_y crop_y_end], size(img_resize,2),size(img_resize,1));
img_crop = img_resize(box(3):box(4),box(1):box(2),:);

%img_crop = img_rot(crop_y:crop_y+img_size-1,crop_x:crop_x+img_size-1);
cropped = img_crop;
end

function r = guard(x, Nx,Ny)
x(x<1)=1;
if x(1)>Nx
    x(1)=Nx;
end
if x(2)>Nx
    x(2)=Nx;
end
if x(3)>Ny
    x(3)=Ny;
end
if x(4)>Ny
    x(4)=Ny;
end
r = x;
end

function [xx, yy] = transform(x, y, ang, s0, s1)
% x,y position
% ang angle
% s0 size of original image
% s1 size of target image

x0 = x - s0(2)/2;
y0 = y - s0(1)/2;
xx = x0*cos(ang) - y0*sin(ang) + s1(2)/2;
yy = x0*sin(ang) + y0*cos(ang) + s1(1)/2;
end