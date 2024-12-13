N = 1e6;
SNR_dB = 0:40;
pError = zeros(size(SNR_dB));
txSymbols = randi([0 8], N, 1);
txSymbols(txSymbols>=8) = 8;
txSignal = exp(1i*2*pi*txSymbols/8).*(txSymbols<8);
avgPwr = mean(abs(txSignal).^2);
txSignal = txSignal/sqrt(avgPwr);
for i = 1:length(SNR_dB)
    rxSignal = awgn(txSignal, SNR_dB(i));
%     noise = 10^(-SNR_dB(i)/20)*complex(randn(size(txSignal)),randn(size(txSignal)))/sqrt(2);
%     rxSignal = txSignal + noise;
    rArray = 0.5;
    r = 0.5;
    isZero = (abs(rxSignal) < r);
    rxSymbols = mod(round(angle(rxSignal)*8/(2*pi)),8);
    rxSymbols(isZero) = 8;
    pError(i) = mean(txSymbols ~= rxSymbols & txSymbols == 8);
end
figure(1)
clf;
semilogy(SNR_dB, pError)
Q = @(x)normcdf(-x);
p = 10.^(SNR_dB/10);
pErrorEst = Q(sqrt(p/2)); % + Q(2*sqrt(2*p)*sin(pi/8));
hold on;
semilogy(SNR_dB, pErrorEst);
grid on;