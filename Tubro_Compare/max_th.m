function y=max_th(a,b)
%****************************************************************
% ���ݸ��������޽��ƺ�����
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��9��3��
% �޸�ʱ�䣺
% �ο����ף���������Turbo��ԭ����Ӧ�ü��������ӹ�ҵ�����磬2004.1
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************

%ln2=log(2);
if abs(a-b)<1
    y=max(a,b)+0.6931;
else
    y=max(a,b);
end