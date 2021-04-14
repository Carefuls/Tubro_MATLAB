clc;
close all;

%图像初始化
lena_jpg = imread('C:\Users\Administrator\Documents\bupt.jpg');
lena_bmp = rgb2gray(lena_jpg);      %转为灰度图像

lena_bmp_list = lena_bmp(:);
lena_2bit = de2bi(lena_bmp_list);
lena_2bit = double(lena_2bit);      %转为双精度数值
lena_2bit_list = lena_2bit(:);      %数据转为列向量

%分析不同信噪比下图像传输质量比较
EbNo1 = -10;
EbNo2 = -8;
EbNo3 = -6;
EbNo4 = -4;

[receive_data1,error_bits1] = Turbo_AWAG_chanel(lena_2bit_list,EbNo1,1); %调用函数 得到过信道图像
[receive_data2,error_bits2] = Turbo_AWAG_chanel(lena_2bit_list,EbNo2,1);
[receive_data3,error_bits3] = Turbo_AWAG_chanel(lena_2bit_list,EbNo3,1);
[receive_data4,error_bits4] = Turbo_AWAG_chanel(lena_2bit_list,EbNo4,1);

receive_lena_1 = receive_image_reshape(receive_data1);          %接收图像
error_image_1 = lena_bmp-receive_lena_1;                        %错误图像

receive_lena_2 = receive_image_reshape(receive_data2);          
error_image_2 = lena_bmp-receive_lena_2;

receive_lena_3 = receive_image_reshape(receive_data3);
error_image_3 = lena_bmp-receive_lena_3;

receive_lena_4 = receive_image_reshape(receive_data4);
error_image_4 = lena_bmp-receive_lena_4;

% 图像分析
figure,
subplot(4,3,1)
imshow(lena_bmp)
title('原始图像');
subplot(4,3,2)
imshow(receive_lena_1)
title('接收图像 (Eb / No = -10)');
subplot(4,3,3)
imshow(error_image_1)
title('错误序列 (Eb / No = -10)');

subplot(4,3,4)
imshow(lena_bmp)
title('原始图像');
subplot(4,3,5)
imshow(receive_lena_2)
title('接收图像 (Eb / No = -8)');
subplot(4,3,6)
imshow(error_image_2)
title('错误序列 (Eb / No = -8)');

subplot(4,3,7)
imshow(lena_bmp)
title('原始图像');
subplot(4,3,8)
imshow(receive_lena_3)
title('接收图像 (Eb / No = -6)');
subplot(4,3,9)
imshow(error_image_3)
title('错误序列 (Eb / No = -6)');

subplot(4,3,10)
imshow(lena_bmp)
title('原始图像');
subplot(4,3,11)
imshow(receive_lena_4)
title('接收图像 (Eb / No = -4)');
subplot(4,3,12)
imshow(error_image_4)
title('错误序列 (Eb / No = -4)');

% 分析卷积码和Turbo码
EbNo11 = 0;
[receive_data12,error_bits12] = ConvolutionalCreat(lena_2bit_list,EbNo11);      %卷积码
[receive_data11,error_bits11] = Turbo_AWAG_chanel(lena_2bit_list,EbNo11,1);     %随机交织器

receive_lena_12 = receive_image_reshape(receive_data12);  
error_image_12 = lena_bmp-receive_lena_12;   
receive_lena_11 = receive_image_reshape(receive_data11); 
error_image_11 = lena_bmp-receive_lena_11;  

figure,
subplot(2,3,1)
imshow(lena_bmp)
title('原始图像');
subplot(2,3,2)
imshow(receive_lena_12)
title('接收图像 (卷积码 Eb / No = 0)');
subplot(2,3,3)
imshow(error_image_12)
title('错误序列 (卷积码 Eb / No = 0)');
subplot(2,3,4)
imshow(lena_bmp)
title('原始图像');
subplot(2,3,5)
imshow(receive_lena_11)
title('接收图像 (Turbo码 Eb / No = 0)');
subplot(2,3,6)
imshow(error_image_11)
title('错误序列 (Turbo码 Eb / No = 0)');

% 分析不同交织器下的图像传输质量
EbNo21 = -6;
[receive_data21,error_bits21] = Turbo_AWAG_chanel(lena_2bit_list,EbNo21,1);  %随机交织器
[receive_data22,error_bits22] = Turbo_AWAG_chanel(lena_2bit_list,EbNo21,2);  %倒序交织器

receive_lena_21 = receive_image_reshape(receive_data21);          
error_image_21 = lena_bmp-receive_lena_21;                        

receive_lena_22 = receive_image_reshape(receive_data22);          
error_image_22 = lena_bmp-receive_lena_22;                        

figure,
subplot(2,3,1)
imshow(lena_bmp)
title('原始图像');
subplot(2,3,2)
imshow(receive_lena_22)
title('接收图像 (随机交织器 Eb / No = -6)');
subplot(2,3,3)
imshow(error_image_22)
title('错误序列 (随机交织器 Eb / No = -6)');
subplot(2,3,4)
imshow(lena_bmp)
title('原始图像');
subplot(2,3,5)
imshow(receive_lena_21)
title('接收图像 (倒序交织器 Eb / No = -6)');
subplot(2,3,6)
imshow(error_image_21)
title('错误序列 (倒序交织器 Eb / No = -6)');