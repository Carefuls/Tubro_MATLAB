%****************************************************************
% ���ݸ�����Trubo������
% �� �� �ˣ�WuYuFei
% ��    λ��
% ����ʱ�䣺1999��
% �޸�ʱ�䣺
% �ο����ף�
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************

function [out,alphaout]=turbo(in);
% turbo������
% in Ϊ�������У�0 1��
g=[1 0 1 1;
   1 1 0 1];

% ���ɾ���1+d^2+d^3
%        1+d+d^3
% 3GPP��׼���ɾ���
[n,K]=size(g);
m=K-1;
nstates=2^m;
%ȷ��״̬��Ŀ
puncture=1;
%�Ƿ�ɾ�� 1 ��ɾ 0 ɾ
rate=1/(2+puncture);
%������
pattern_ordinal=1:length(in);
%----------------------------------
%[temp,alpha]=sort(rand(1,length(in)));
%�õ������֯��
%----------------------------------
alpha=interleaver_3GPP(pattern_ordinal);
%�õ�3GPP��׼��֯��
%----------------------------------
en_output=encoderm(in,g,alpha,puncture);
%����
alphaout=alpha;
% ��֯�����
out=en_output;
% �������