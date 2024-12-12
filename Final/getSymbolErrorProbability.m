N = 5e6;
SNR_dB = 0:40;
pError = zeros(size(SNR_dB));
txSymbols = randi([0 16], N, 1);
txSymbols(txSymbols>=8) = 8;
txSignal = exp(1i*2*pi*txSymbols/8).*(txSymbols<8);
for i = 1:length(SNR_dB)
    rxSignal = awgn(txSignal, SNR_dB(i) + 10*log10(2));
    rArray = 0.5;
    r = 0.5;
    isZero = (abs(rxSignal) < r);
    rxSymbols = mod(round(angle(rxSignal)*8/(2*pi)),8);
    rxSymbols(isZero) = 8;
    pError(i) = mean(txSymbols ~= rxSymbols);
end
figure(1)
clf;
semilogy(SNR_dB, pError)
Q = @(x)normcdf(-x);
p = 10.^(SNR_dB/10);
pErrorEst = 8*Q(sqrt(p)) + Q(2*sqrt(p)*sin(pi/8));
hold on;
semilogy(SNR_dB, pErrorEst);
grid on;