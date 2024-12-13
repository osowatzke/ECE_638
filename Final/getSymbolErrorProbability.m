% Number of samples to generate
N = 5e6;

% Range of SNR to sweep
SNR_dB = 0:20;

% Allocate empty array for symbol error probabilities
pError = zeros(size(SNR_dB));

% Create random transmitted symbols
% Constellation point at origin occurs with probability of 0.5
% All other constellation points occur with probability of 0.5/8
txSymbols = randi([0 16], N, 1);
txSymbols(txSymbols>=8) = 8;
txSignal = exp(1i*2*pi*txSymbols/8).*(txSymbols<8);

% Normalize the signal so it has an average energy of 1
avgPwr = mean(abs(txSignal).^2);
txSignal = txSignal/sqrt(avgPwr);

% Get constellation points for comparison
si = [1/sqrt(avgPwr)*exp(1i*2*pi*(0:7)/8), 0];

% Loop for each SNR
for i = 1:length(SNR_dB)

    % Pass signal through AWGN channel
    rxSignal = awgn(txSignal, SNR_dB(i));

    % Demodulate symbols
    [~,rxSymbols] = min(abs(rxSignal.'-si.'));
    rxSymbols = rxSymbols.'-1;

    % Determine the probability of error
    pError(i) = mean(txSymbols ~= rxSymbols);
end

% Plot the results
figure(1)
clf;
semilogy(SNR_dB, pError,'LineWidth',1.5)
xlabel('SNR (dB)')
ylabel('Probability of Symbol Error')
title('Probability of Symbol Error in AWGN Channel')

% Estimate probability of symbol error
Q = @(x)normcdf(-x);
p = 10.^(SNR_dB/10);
pErrorEst = 4*Q(sqrt(p)) + Q(2*sqrt(p)*sin(pi/8));

% Plot estimate
hold on;
semilogy(SNR_dB, pErrorEst,'LineWidth',1.5);
grid on;

% Add legend
legend('Measured','Estimated');