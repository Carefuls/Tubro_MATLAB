function [receive_data,error_bits] = Turbo_AWAG_chanel(data,EbNo,intrlvrIndices_type)
    
    
    noiseVar = 10^(-EbNo/10);       %信噪比转换
    rng default
    %% 交织器
    frmLen = length(data);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 交织器类型的选取 %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%   1表示随机交织器 2表示倒序交织器 3表示分组交织器   %%%%%%%%%%%%%
    if intrlvrIndices_type == 1
        intrlvrIndices = randperm(frmLen);      %随机交织 利用randperm产生随机数列
    elseif intrlvrIndices_type == 2
        intrlvrIndices = (frmLen:-1:1);         %倒序排列
    elseif intrlvrIndices_type == 3             %分组交织
        
        a = 1:frmLen;
        b = zeros(1,frmLen);
        m =16;
        n =frmLen/m;
        
        for i=1:frmLen
            j = mod(i-1,n)*m+floor((i-1)/n)+1;
            b(j) = a(i);
        end
        intrlvrIndices = b;
    end
    %% Turbo
    % Create a turbo encoder and decoder pair using the trellis structure given
    % by |poly2trellis(4,[13 15 17],13)| and |intrlvrIndices|.
    
    hTEnc = comm.TurboEncoder('TrellisStructure',poly2trellis(4, ...
        [13 15 17],13),'InterleaverIndices',intrlvrIndices);
    
    hTDec = comm.TurboDecoder('TrellisStructure',poly2trellis(4, ...
        [13 15 17],13),'InterleaverIndices',intrlvrIndices, ...
        'NumIterations',4);     %Iterations表示迭代，该参数意为迭代阶数
    %% BPSK
    % Create a BPSK modulator and demodulator pair, where the demodulator
    % outputs soft bits determined by using a log-likelihood ratio method.
    hMod = comm.BPSKModulator;
    hDemod = comm.BPSKDemodulator('DecisionMethod','Log-likelihood ratio', ...
        'Variance',noiseVar);

    %% AWAG
    % Create an AWGN channel object and an error rate object.
    hChan = comm.AWGNChannel('EbNo',EbNo);
    hError = comm.ErrorRate;

    %% 数据处理
    
    encodedData = step(hTEnc,data);
    modSignal = step(hMod,encodedData);
    receivedSignal = step(hChan,modSignal);
    demodSignal = step(hDemod,receivedSignal);
    receiveBits = step(hTDec,-demodSignal);
    
%     receiveBits = zeros(length(demodSignal),1);
%     
%     for i=1:length(demodSignal)
%         if demodSignal(i)>=0
%             receiveBits(i)=0;
%         elseif demodSignal(i)<0
%             receiveBits(i)=1;
%         end
%     end
    
    errorStats = step(hError,data,receiveBits);
    
    
    receive_data = receiveBits;
    error_bits = errorStats(1);



end