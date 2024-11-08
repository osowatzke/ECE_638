% Function computes the channel capacity
%
%   Inputs:
%       Hi      Subcarrier Frequency Response
%       P       Transmit Power (W)
%       W       Subcarrier bandwidth
%       N0      Noise Power (W/Hz)
%       
%   Outputs:
%       C       Channel Capacity bits/s
%       ptsh    Threshold SNR
%
function [C, ptsh] = getChannelCapacity(Hi, P, W, N0)
    
    % Get subcarrier SNR
    pi = abs(Hi).^2*P/(N0*W);
    
    % Get Set of Minimum Threshold Values
    ptsh = unique(pi).';

    % Allocate arrays for channel capacity
    C = zeros(size(ptsh));

    % Loop over all minimum threshold values
    for i = 1:length(ptsh)

        % Get boolean array to select all channels above assumed SNR
        sel = pi >= ptsh(i);

        % Compute actual threshold
        tmp = sum(sel)/(1 + sum(1./pi(sel)));

        % Only compute channel capacity if threshold SNR is
        % is consistent with assumed array bounds
        if (tmp <= ptsh(i))
            C(i) = sum(W*log2(pi(sel)/tmp));
        end

        % Overwrite starting SNR threshold with true SNR threshold
        ptsh(i) = tmp;
    end

    % Determine which threshold selection maximizes channel capacity
    [C,I] = max(C);

    % Select corresponding threshold
    ptsh = ptsh(I);
end