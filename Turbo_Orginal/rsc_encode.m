function y = rsc_encode(g,x,y)
% Copyright Nov. 1998 Yufei Wu
% MPRG lab, Virginia Tech.
% for academic use only

% encodes a block of data x (0/1)with a recursive systematic
% convolutional code with generator vectors in g, and
% returns the output in y (0/1).
% if end>0, the trellis is perfectly terminated
% if end<0, it is left unterminated;

% determine the constraint length (K), memory (m), and rate (1/n)
% and number of information bits.
[n,K] = size(g);
m = K - 1;
if y>0
  L_info = length(x);
  L_total = L_info + m;
else
  L_total = length(x);
  L_info = L_total - m;
end 


% initialize the state vector
state = zeros(1,m);%初始状态用的是00...

% generate the codeword %对每个输入的数据进行编码
for i = 1:L_total
   if y<0 | (y>0 & i<=L_info)
      d_k = x(1,i);
   elseif y>0 & i>L_info
      % terminate the trellis
      d_k = rem( g(1,2:K)*state', 2 );
   end
 
   a_k = rem( g(1,:)*[d_k state]', 2 );%除2取余是为了使码字保持在01两种选择 或者说是为了实现二进制
   [output_bits, state] = encode_bit(g, a_k, state);%完成state的迭代和反馈的更新
   % since systematic, first output is input bit
   output_bits(1,1) = d_k;
   y(n*(i-1)+1:n*i) = output_bits;
end
