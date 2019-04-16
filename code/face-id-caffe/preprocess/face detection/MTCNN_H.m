clear;
clc;
%list of images
% imglist=importdata('G:\MTCNN_face_detection_alignment-master\code\codes\MTCNNv1\imglist.txt')
%minimum size of face
minsize=20;

%path of toolbox
caffe_path='E:\caffe\caffe-master\matlab';
pdollar_toolbox_path='G:\data_deal\ToolBox\toolbox-master';
caffe_model_path='G:\data_deal\MTCNN_face_detection_alignment-master\code\codes\MTCNNv1\model';
addpath(genpath(caffe_path));
addpath(genpath(pdollar_toolbox_path));

%use cpu
%caffe.set_mode_cpu();
gpu_id=0;
caffe.set_mode_gpu();	
caffe.set_device(gpu_id);

%three steps's threshold
threshold=[0.6 0.7 0.7]

%scale factor
factor=0.709;

%load caffe models
prototxt_dir =strcat(caffe_model_path,'/det1.prototxt');
model_dir = strcat(caffe_model_path,'/det1.caffemodel');
PNet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir = strcat(caffe_model_path,'/det2.prototxt');
model_dir = strcat(caffe_model_path,'/det2.caffemodel');
RNet=caffe.Net(prototxt_dir,model_dir,'test');	
prototxt_dir = strcat(caffe_model_path,'/det3.prototxt');
model_dir = strcat(caffe_model_path,'/det3.caffemodel');
ONet=caffe.Net(prototxt_dir,model_dir,'test');
faces=cell(0);	
% for i=1:length(imglist)
%   i
% img=imread(imglist{i});
%%%%%%%%%%%%%%%%%%%%%%≈‰÷√caffe%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subdir=dir('E:\data_hzg\multi I\');
for i=3:length(subdir)
    var_name=strcat('E:\data_hzg\multi I\',subdir(i).name);
    vardir=dir(var_name);
    for t1=3:1:length(vardir)
        type_name=strcat(var_name,'\',vardir(t1).name);
%         typedir=dir(type_name);
%         for t2=3:2:length(typedir)
%             photo_name=strcat(type_name,'\',typedir(t2).name);
%             photodir=dir(photo_name);
%             for t3=3:length(photodir)
%                 
%             
% % subdir=dir('H:\brldata\data_f2\_hongweijie\01\color');
%      imagepath = strcat(photo_name,'\',photodir(t3).name);
	img=imread(type_name);
%     for i=1:1:2
	%we recommend you to set minsize as x * short side
	%minl=min([size(img,1) size(img,2)]);
	%minsize=fix(minl*0.1)
    tic
    [boudingboxes points]=detect_face(img,minsize,PNet,RNet,ONet,threshold,false,factor);
	toc
    faces{1,1}={boudingboxes};
	faces{1,2}={points'};
	%show detection result
	numbox=size(boudingboxes,1);
	imshow(img)
	hold on; 
	for j=1:numbox
		plot(points(1:5,j),points(6:10,j),'g.','MarkerSize',10);
		r=rectangle('Position',[boudingboxes(j,1:2) boudingboxes(j,3:4)-boudingboxes(j,1:2)],'Edgecolor','g','LineWidth',3);
    txtpath=strcat(type_name(1:end-4), '.txt');
        fid=fopen(txtpath,'wt');
        for index=1:10
        fprintf(fid,strcat(num2str(points(index,j)),';'));
        end
        fprintf(fid,'\n');
        for index=1:4
        fprintf(fid,strcat(num2str(boudingboxes(j,index)),';'));
        end
        fclose(fid);
        end
        end
    end
   
    
%     hold off; 
% 	pause
%   end
% save result box landmark