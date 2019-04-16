clear;
clc;
% addpath(genpath('/home/scw4750/github/global_tool'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%胡振国%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%基本网络参数设置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
caffe_path='E:\caffe\caffe-master\matlab';
rank_n=50;
% for lightencnn
% prototxt='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C_deploy.prototxt';
% caffemodel='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C.caffemodel';
% prototxt='G:\data_deal\LightCNN\proto\LightenedCNN_C_deploy.prototxt';
% %%%网络协议
% caffemodel='G:\data_deal\LightCNN\model\LightenedCNN_C.caffemodel';
% %%%网络模型
% data_key='data';
% %%%数据输入层名称
% feature_key='eltwise_fc1';
% %%%抽取特征层名称
% is_gray=true;
% data_size=[128 128];
% %%%输入数据的尺寸
% norm_type=0;  
% % type=0 indicates that the data is just divided by 255
% averageImg=[0 0 0];
% %%%是否要减去平均值
% preprocess_param.do_alignment=false;
% preprocess_param.align_param.alignment_type='lightcnn';

% %for vgg
% prototxt='G:\data_deal\VGG_FACE\vgg_face_caffe\vgg_face_caffe\VGG_FACE_deploy.prototxt';
% caffemodel='G:\data_deal\VGG_FACE\vgg_face_caffe\vgg_face_caffe\VGG_FACE.caffemodel';
% data_key='data';
% feature_key='fc7';
% is_gray=false;
% data_size=[224 224];
% norm_type=1;
% averageImg=[129.1863,104.7624,93.5940] ;   %%%RGB
% preprocess_param.do_alignment=false;


%for centerloss
prototxt='E:\data_hzg\sphereface-master-m\sphereface-master\train\code\sphereface_deploy.prototxt';
caffemodel='E:\data_hzg\sphereface-master-m\sphereface-master\train\code\sphereface_model.caffemodel';
data_key='data';
feature_key='fc5';
is_gray=false;
data_size=[112 96];
norm_type=2;
averageImg=[0 0 0];
preprocess_param.do_alignment=false;
preprocess_param.align_param.alignment_type='centerloss';
distance_type='cos';


% %for ResNet
%prototxt='/home/scw4750/github/2D/2D_models/ResNet/ResNet-50-deploy.prototxt';
%caffemodel='/home/scw4750/github/2D/2D_models/ResNet/ResNet-50-model.caffemodel';
% data_key='data';
% feature_key='pool5';
% is_gray=false;
% data_size=[224 224];
% norm_type=1;
% averageImg=[123, 104, 127] ;    %%%RGB
% preprocess_param.do_alignment=true;
% preprocess_param.align_param.alignment_type='lightcnn';
% distance_type='cos';


net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;

matrix_param.distance_type='cos';

preprocess_param.is_continue_without_landmarks=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%引入gallery和probe%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subdir='E:\data_hzg\multi I_align\';
% sub=dir('E:\data_hzg\multi I_align');
%%这个路径保存有所有的gallery image folder和probe image folder
% suddir2='E:\data_hzg\multi I_align_labels\'
% sub2=dir('E:\data_hzg\multi I_align_labels');
%%%这个路径存储相应的labels
% for h_1=15:length(sub)
%     probe_name=sub(h_1).name;
%     labels_name=sub2(h_1).name;
probe_dir=strcat('E:\data_hzg\multi I_align_sphere\','z_probe_20','\');
probe_txt=strcat('E:\data_hzg\multi I_align_sphere_labels\','labels_z_probe_20.txt');
%%%这是gallery的相关文件
gallery_dir= 'E:\data_hzg\multi I_align_sphere\gallery\';
gallery_txt='E:\data_hzg\multi I_align_sphere_labels\labels_gallery.txt';
% path= probe_name;
% path='E:\data_hzg\anaylisi_matrix';
analysis = get_analysis_matrix_from_net(gallery_dir,probe_dir,...
    gallery_txt,probe_txt,caffe_path,prototxt,caffemodel, ...
    net_param,preprocess_param,matrix_param);
%%%%这是个自定义函数如何得到一个probe对gallery的分析矩阵
% save('analysis');
rank_score=compute_cmc_by_analysis_matrix(analysis);
plot(rank_score)
fid=fopen('C:\Users\Administrator\Desktop\FACE_ID.txt','at');
for h_2=1:10
    fprintf(fid,'%f ',rank_score(h_2));
end
fprintf(fid,'\n');
fclose(fid);
plot(rank_score);
 xlabel('rank-n');
 ylabel('accuracy');
title('sphere-face-all');




    

