%****************************************************************
% ���ݸ�����AWGN�ŵ���ũ�ޣ�Shannon Limit��
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ������Ϣ����ѧԺ
% ����ʱ�䣺2005��11��2��
% �޸�ʱ�䣺
% �ο����ף���������Turbo��ԭ����Ӧ�ã��ڶ���
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
clear;
r=0:0.01:1;
EcNo=10*log10((2.^(2.*r)-1)./(2.*r));
plot(EcNo,r)
%EcNo=(2.^(2.*r)-1)./(2.*r);
%semilogx(EcNo,r)
xlabel('E_b/N_0 (dB)');
ylabel('Code Rate');
title('�����������AWGN�ŵ���Shannon��');
grid;