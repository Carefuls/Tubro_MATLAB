function y=receive_image_reshape(receive_data)
 
    receive_data_2bit = reshape(receive_data,length(receive_data)/8,8);
    receice_10bit = bi2de(receive_data_2bit);
    receive_image = reshape(receice_10bit,sqrt(length(receice_10bit)),sqrt(length(receice_10bit))); %����ͼ��
    receive_lena = uint8(receive_image);            %˫������ֵת��ΪUINT8�ͺ�
    y = receive_lena;
    
end