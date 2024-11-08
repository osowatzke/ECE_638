%% Option 1
% 32 subcarriers of bandwidth 2 MHz
% H_even = sqrt(2), H_odd = 1
Hi = reshape([sqrt(2)*ones(1,16); ones(1,16)],[],1);
P = 10e-3;
N0 = 1e-9;
W = 2e6;

% Compute channel capacity
[C, ptsh] = getChannelCapacity(Hi,P,W,N0);

% Display results
fprintf('32 Subcarriers with BW=2MHz:\n')
displayResults(C, ptsh);

%% Option 2
% 2 subcarriers of bandwidth 32 MHz
% H_even = sqrt(2), H_odd = 1
Hi = [sqrt(2); 1];
P = 10e-3;
N0 = 1e-9;
W = 32e6;

% Compute channel capacity
[C, ptsh] = getChannelCapacity(Hi,P,W,N0);

% Display results
fprintf('2 Subcarriers with BW=32MHz:\n')
displayResults(C, ptsh);

% Function displays results
function displayResults(C, ptsh)

    % Get units for channel capacity
    if C < 1e3
        C_units = 'bps';
    elseif C < 1e6
        C = C * 1e-3;
        C_units = 'kbps';
    elseif C < 1e9
        C = C * 1e-6;
        C_units = 'Mbps';
    else
        C = C * 1e-9;
        C_units = 'Gbps';
    end

    % Print C and ptsh
    fprintf('\tC = %g %s\n', C, C_units);
    fprintf('\tptsh = %g\n\n', ptsh);
end