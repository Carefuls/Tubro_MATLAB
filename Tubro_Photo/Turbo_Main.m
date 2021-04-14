clc;
close all;

%ͼ���ʼ��
lena_jpg = imread('C:\Users\Administrator\Documents\bupt.jpg');
lena_bmp = rgb2gray(lena_jpg);      %תΪ�Ҷ�ͼ��

lena_bmp_list = lena_bmp(:);
lena_2bit = de2bi(lena_bmp_list);
lena_2bit = double(lena_2bit);      %תΪ˫������ֵ
lena_2bit_list = lena_2bit(:);      %����תΪ������

%������ͬ�������ͼ���������Ƚ�
EbNo1 = -10;
EbNo2 = -8;
EbNo3 = -6;
EbNo4 = -4;

[receive_data1,error_bits1] = Turbo_AWAG_chanel(lena_2bit_list,EbNo1,1); %���ú��� �õ����ŵ�ͼ��
[receive_data2,error_bits2] = Turbo_AWAG_chanel(lena_2bit_list,EbNo2,1);
[receive_data3,error_bits3] = Turbo_AWAG_chanel(lena_2bit_list,EbNo3,1);
[receive_data4,error_bits4] = Turbo_AWAG_chanel(lena_2bit_list,EbNo4,1);

receive_lena_1 = receive_image_reshape(receive_data1);          %����ͼ��
error_image_1 = lena_bmp-receive_lena_1;                        %����ͼ��

receive_lena_2 = receive_image_reshape(receive_data2);          
error_image_2 = lena_bmp-receive_lena_2;

receive_lena_3 = receive_image_reshape(receive_data3);
error_image_3 = lena_bmp-receive_lena_3;

receive_lena_4 = receive_image_reshape(receive_data4);
error_image_4 = lena_bmp-receive_lena_4;

% ͼ�����
figure,
subplot(4,3,1)
imshow(lena_bmp)
title('ԭʼͼ��');
subplot(4,3,2)
imshow(receive_lena_1)
title('����ͼ�� (Eb / No = -10)');
subplot(4,3,3)
imshow(error_image_1)
title('�������� (Eb / No = -10)');

subplot(4,3,4)
imshow(lena_bmp)
title('ԭʼͼ��');
subplot(4,3,5)
imshow(receive_lena_2)
title('����ͼ�� (Eb / No = -8)');
subplot(4,3,6)
imshow(error_image_2)
title('�������� (Eb / No = -8)');

subplot(4,3,7)
imshow(lena_bmp)
title('ԭʼͼ��');
subplot(4,3,8)
imshow(receive_lena_3)
title('����ͼ�� (Eb / No = -6)');
subplot(4,3,9)
imshow(error_image_3)
title('�������� (Eb / No = -6)');

subplot(4,3,10)
imshow(lena_bmp)
title('ԭʼͼ��');
subplot(4,3,11)
imshow(receive_lena_4)
title('����ͼ�� (Eb / No = -4)');
subplot(4,3,12)
imshow(error_image_4)
title('�������� (Eb / No = -4)');

% ����������Turbo��
EbNo11 = 0;
[receive_data12,error_bits12] = ConvolutionalCreat(lena_2bit_list,EbNo11);      %�����
[receive_data11,error_bits11] = Turbo_AWAG_chanel(lena_2bit_list,EbNo11,1);     %�����֯��

receive_lena_12 = receive_image_reshape(receive_data12);  
error_image_12 = lena_bmp-receive_lena_12;   
receive_lena_11 = receive_image_reshape(receive_data11); 
error_image_11 = lena_bmp-receive_lena_11;  

figure,
subplot(2,3,1)
imshow(lena_bmp)
title('ԭʼͼ��');
subplot(2,3,2)
imshow(receive_lena_12)
title('����ͼ�� (����� Eb / No = 0)');
subplot(2,3,3)
imshow(error_image_12)
title('�������� (����� Eb / No = 0)');
subplot(2,3,4)
imshow(lena_bmp)
title('ԭʼͼ��');
subplot(2,3,5)
imshow(receive_lena_11)
title('����ͼ�� (Turbo�� Eb / No = 0)');
subplot(2,3,6)
imshow(error_image_11)
title('�������� (Turbo�� Eb / No = 0)');

% ������ͬ��֯���µ�ͼ��������
EbNo21 = -6;
[receive_data21,error_bits21] = Turbo_AWAG_chanel(lena_2bit_list,EbNo21,1);  %�����֯��
[receive_data22,error_bits22] = Turbo_AWAG_chanel(lena_2bit_list,EbNo21,2);  %����֯��

receive_lena_21 = receive_image_reshape(receive_data21);          
error_image_21 = lena_bmp-receive_lena_21;                        

receive_lena_22 = receive_image_reshape(receive_data22);          
error_image_22 = lena_bmp-receive_lena_22;                        

figure,
subplot(2,3,1)
imshow(lena_bmp)
title('ԭʼͼ��');
subplot(2,3,2)
imshow(receive_lena_22)
title('����ͼ�� (�����֯�� Eb / No = -6)');
subplot(2,3,3)
imshow(error_image_22)
title('�������� (�����֯�� Eb / No = -6)');
subplot(2,3,4)
imshow(lena_bmp)
title('ԭʼͼ��');
subplot(2,3,5)
imshow(receive_lena_21)
title('����ͼ�� (����֯�� Eb / No = -6)');
subplot(2,3,6)
imshow(error_image_21)
title('�������� (����֯�� Eb / No = -6)');