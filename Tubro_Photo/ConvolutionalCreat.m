function [receive_data,error_bits] = ConvolutionalCreat(data,EbNo)

noiseVar = 10^(-EbNo/10);       %信噪比转换

%% 卷积码
hConEnc = comm.ConvolutionalEncoder('TrellisStructure',poly2trellis(4, ...
        [13 15 17],13));
hDec = comm.ViterbiDecoder('TrellisStructure',poly2trellis(4, ...
        [13 15 17],13),'InputFormat','Hard');

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
%% 
% hConEnc = comm.ConvolutionalEncoder;
% 
% hChan = comm.AWGNChannel('NoiseMethod', ...
%     'Signal to noise ratio (SNR)',...
%     'SNR',noiseVar);
% hDemod = comm.DPSKDemodulator('BitOutput',true);
% hDec = comm.ViterbiDecoder('InputFormat','Hard');
% hError = comm.ErrorRate('ComputationDelay',3,'ReceiveDelay', 34);

%% 

    encodedData = step(hConEnc,data);
    modSignal = step(hMod,encodedData);
    receivedSignal = step(hChan,modSignal);
    demodSignal = step(hDemod,receivedSignal);
    receiveBits = step(hDec,-demodSignal);
    
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


% 
% for counter = 1:20
%     data = randi([0 1],30,1);
%     encodedData = step(hConEnc, data);
%     modSignal = step(hMod, encodedData);
%     receivedSignal = step(hChan, modSignal);
%     demodSignal = step(hDemod, receivedSignal);
%     receivedBits = step(hDec, demodSignal);
%     errors = step(hError, data, receivedBits);
% end
% %%
% % Display the number of errors.
% errors(2)
end
