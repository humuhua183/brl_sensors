clear
clc
subdir=dir('E:\data_hzg\multi I');
outdir=dir('E:\data_hzg\multi I_align_sphere');
for i=3:length(subdir)
    var_name=strcat('E:\data_hzg\multi I\',subdir(i).name);
    ovar_name=strcat('E:\data_hzg\multi I_align_sphere\',subdir(i).name);
    vardir=dir(var_name);
     mkdir(ovar_name);
%     for t1=3:1:length(vardir)
%         type_name=strcat(var_name,'\',vardir(t1).name);
%         otype_name=strcat(ovar_name,'\',vardir(t1).name);
%         typedir=dir(type_name);
%         mkdir(otype_name);
%          for t2=3:3
%             photo_name=strcat(type_name,'\',typedir(t2).name);
%             ophoto_name=strcat(otype_name,'\',typedir(t2).name);
%             photodir=dir(photo_name);
%             mkdir(ophoto_name);
             ssubdir='x';
            alignment(var_name,var_name,48,40,128, ovar_name,'.jpg','jpg','txt');
%             ssubdir='x';
         end
%     end
% end
