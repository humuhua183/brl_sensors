# brl_sensors
## 1.数据人员信息 ##
数据人员信息表格记录了SCU-RGB-HLD-Databases采集人员的信息，其中session1是原始记录，session2是记录了两个view中重复的人员信息，final_view1记录了最终处理清洗干净之后的view1的人员：总人数246，具备完整信息有223人，标记为1，另23人无高精数据，标记为2缺3D；246人中有31人与view2重复，在是否重复中标记是（1）；final_view2中记录了最终处理清洗干净后的view2中的人员信息，人员总数为713，具备完整数据信息的674人，与view1重复31人，缺失高精度信息人数8人。

因此整个数据集包含人员个数928人，完备数据人数897人。
为此在实验中view1和view2中与view1重复或缺失高精的人均作为测试集。
## 2.code ##
code文件夹中存储了相应的代码：
###3d2depth：
这个路径下的代码用于高精三维点云生成深度图像，其中wrl2mat，是将wrl文件中的点云相关信息，写入matlab，产生mat文件。
generating depth map中的代码是将mat文件中的点云，根据低精数据的特征点生成转置矩阵将点云生成与低精深度图像对应的高精度深度图像。
以上代码均为matlab的.m文件。
###face-id-caffe
此路径下的代码用于人脸identification。
preprocess中有人脸检测和对齐的相关方法，feature extraction中是用LCNN或VGG等网络抽取特征，计算特征矩阵完成identification的代码。
以上代码均为.m文件。