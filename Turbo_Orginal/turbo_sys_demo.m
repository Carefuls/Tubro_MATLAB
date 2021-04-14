% This script simulates the classical turbo encoding-decoding system. 
% It simulates parallel concatenated convolutional codes.模拟并行级联卷积
% Two component rate 1/2 RSC (Recursive Systematic Convolutional) component
% encoders are assumed.两个组件率1/2 RSC(递归系统卷积)组件编码器
% First encoder is terminated with tails bits. (Info + tail) bits are
% scrambled and passed to 第一个编码器与尾巴部分终止。(信息+尾巴)位炒和传递给
% the second encoder, while second encoder is left open without tail bits
% of itself.而第二编码器本身就是开没有尾巴的
% Random information bits are modulated into +1/-1, and transmitted through
% a AWGN channel.随机比特信息调制到+ 1/-1,通过AWGN信道和传输
% Interleavers are randomly generated for each frame.每一帧梳是随机生成的。
% Log-MAP algorithm without quantization or approximation is used.
% By making use of ln(e^x+e^y) = max(x,y) + ln(1+e^(-abs(x-y))),
% the Log-MAP can be simplified with a look-up table for the correction
% function.Log-MAP可以简化的查表修正功能
% If use approximation ln(e^x+e^y) = max(x,y), it becomes MAX-Log-MAP.
%
% Copyright Nov 1998, Yufei Wu
% MPRG lab, Virginia Tech.
% for academic use only

clear all

% Write display messages to a text file
diary turbo_logmap.txt

% Choose decoding algorithm 选择解码算法
dec_alg = input(' Please enter the decoding algorithm. (0:Log-MAP, 1:SOVA)  default 0    ');
if isempty(dec_alg)
   dec_alg = 0;
end

% Frame size帧大小
L_total = input(' Please enter the frame size (= info + tail, default: 400)   ');
if isempty(L_total)
   L_total = 400;	 % infomation bits plus tail bits信息位加上尾位
end

% Code generator编码发生器
g = input(' Please enter code generator: ( default: g = [1 1 1; 1 0 1 ] )      ');
if isempty(g)
   g = [ 1 1 1;
         1 0 1 ];
end
%g = [1 1 0 1; 1 1 1 1];
%g = [1 1 1 1 1; 1 0 0 0 1];

[n,K] = size(g); 
m = K - 1;%寄存器个数（也是状态数）
nstates = 2^m;

%puncture = 0, puncturing into rate 1/2; 
%puncture = 1, no puncturing %是否删余
puncture = input(' Please choose punctured / unpunctured (0/1): default 0     ');
if isempty(puncture) 
    puncture = 0;
end

% Code rate编码速率
rate = 1/(2+puncture);   

% Fading amplitude衰落幅度; a=1 in AWGN channel
a = 1; 

% Number of iterations迭代次数
niter = input(' Please enter number of iterations for each frame: default 5');
if isempty(niter) 
   niter = 5;
end   
% Number of frame errors to count as a stop criterior数量的帧错误计数停止文中??
ferrlim = input(' Please enter number of frame errors to terminate: default 15');
if isempty(ferrlim)
   ferrlim = 15;
end   

EbN0db = input(' Please enter Eb/N0 in dB : default [2.0]    ');
if isempty(EbN0db)
   EbN0db = [2.0];
end

fprintf('\n\n----------------------------------------------------\n'); 
if dec_alg == 0
   fprintf(' === Log-MAP decoder === \n');
else
   fprintf(' === SOVA decoder === \n');
end
fprintf(' Frame size = %6d\n',L_total);
fprintf(' code generator: \n');
for i = 1:n
    for j = 1:K
        fprintf( '%6d', g(i,j));
    end
    fprintf('\n');
end        
if puncture==0
   fprintf(' Punctured, code rate = 1/2 \n');
else
   fprintf(' Unpunctured, code rate = 1/3 \n');
end
fprintf(' iteration number =  %6d\n', niter);
fprintf(' terminate frame errors = %6d\n', ferrlim);
fprintf(' Eb / N0 (dB) = ');
for i = 1:length(EbN0db)
    fprintf('%10.2f',EbN0db(i));
end
fprintf('\n----------------------------------------------------\n\n');
    
fprintf('+ + + + Please be patient. Wait a while to get the result. + + + +\n');

for nEN = 1:length(EbN0db)
   en = 10^(EbN0db(nEN)/10);      % convert Eb/N0 from unit db to normal numbers
   L_c = 4*a*en*rate; 	% reliability value of the channel可靠性价值的通道
   sigma = 1/sqrt(2*rate*en); 	% standard deviation of AWGN noise噪音标准偏差的情况

% Clear bit error counter and frame error counter清除错误计数器和帧错误计数器
   errs(nEN,1:niter) = zeros(1,niter);
   nferr(nEN,1:niter) = zeros(1,niter);

   nframe = 0;    % clear counter of transmitted frames清除传输帧计数器
   while nferr(nEN, niter)<ferrlim
      nframe = nframe + 1;    
      x = round(rand(1, L_total-m));    % info. bits
      [temp, alpha] = sort(rand(1,L_total));        % random interleaver mapping交织器
      en_output = encoderm( x, g, alpha, puncture ) ; % encoder output (+1/-1)
        %接收编码，加上信道条件  
      r = en_output+sigma*randn(1,L_total*(2+puncture)); % received bits
      yk = demultiplex(r,alpha,puncture); % demultiplex to get input for decoder 1 and 2
      
% Scale the received bits   接收到的比特规模
      rec_s = 0.5*L_c*yk;

% Initialize extrinsic information   初始化外部信息   
      L_e(1:L_total) = zeros(1,L_total);
      
      for iter = 1:niter
% Decoder one译码器
         L_a(alpha) = L_e;  % a priori info. 先验信息
         if dec_alg == 0
            L_all = logmapo(rec_s(1,:), g, L_a, 1);  % complete info.完整的信息
         else   
            L_all = sova0(rec_s(1,:), g, L_a, 1);  % complete info.
         end   
         L_e = L_all - 2*rec_s(1,1:2:2*L_total) - L_a;  % extrinsic info.外在的信息

% Decoder two         
         L_a = L_e(alpha);  % a priori info.
         if dec_alg == 0
            L_all = logmapo(rec_s(2,:), g, L_a, 2);  % complete info.  
         else
            L_all = sova0(rec_s(2,:), g, L_a, 2);  % complete info. 
         end
         L_e = L_all - 2*rec_s(2,1:2:2*L_total) - L_a;  % extrinsic info.
         
% Estimate the info. bits   估计信息位     
         xhat(alpha) = (sign(L_all)+1)/2;

% Number of bit errors in current iteration有些错误在当前迭代的数量
         err(iter) = length(find(xhat(1:L_total-m)~=x));
% Count frame errors for the current iteration为当前迭代计算帧错误
         if err(iter)>0
            nferr(nEN,iter) = nferr(nEN,iter)+1;
         end   
      end	%iter
      
% Total number of bit errors for all iterations所有迭代的位错误总数
      errs(nEN,1:niter) = errs(nEN,1:niter) + err(1:niter);

      if rem(nframe,3)==0 | nferr(nEN, niter)==ferrlim
% Bit error rate
         ber(nEN,1:niter) = errs(nEN,1:niter)/nframe/(L_total-m);
% Frame error rate
         fer(nEN,1:niter) = nferr(nEN,1:niter)/nframe;

% Display intermediate results in process  
         fprintf('************** Eb/N0 = %5.2f db **************\n', EbN0db(nEN));
         fprintf('Frame size = %d, rate 1/%d. \n', L_total, 2+puncture);
         fprintf('%d frames transmitted, %d frames in error.\n', nframe, nferr(nEN, niter));
         fprintf('Bit Error Rate (from iteration 1 to iteration %d):\n', niter);
         for i=1:niter
            fprintf('%8.4e    ', ber(nEN,i));
         end
         fprintf('\n');
         fprintf('Frame Error Rate (from iteration 1 to iteration %d):\n', niter);
         for i=1:niter
            fprintf('%8.4e    ', fer(nEN,i));
         end
         fprintf('\n');
         fprintf('***********************************************\n\n');

% Save intermediate results 
         save turbo_sys_demo EbN0db ber fer
      end
      
   end		%while
end 		%nEN

diary off
