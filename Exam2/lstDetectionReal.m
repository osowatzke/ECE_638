classdef lstDetectionReal < handle
    properties
        Q;
        R;
        numSymbols;
    end
    methods (Static)

        % Function decomposes a space time matrix into A and B matrices
        function [A,B] = decompose(X)

            % Get all the symbolic variables in space-time code
            % Each symbolic variable represents a symbolic in space-time code
            vars = symvar(X);

            % Allocate empty arrays for A and B matrices
            A = zeros([size(X),length(vars)]);
            B = zeros([size(X),length(vars)]);

            % Compute each A and B matrix
            for i = 1:length(vars)

                % Zero out all variables except the one of interest
                zeroIdx = setdiff(1:length(vars),i);
                temp = subs(X,vars(zeroIdx),zeros(size(vars(zeroIdx))));

                % substitute 1 and 1i to find A and B matrices
                A(:,:,i) = subs(temp,vars(i),1);
                B(:,:,i) = imag(subs(temp,vars(i),1i));
            end
        end
    end
    methods
        function self = lstDetectionReal(X, H)

            % Form H tilde matrix from A and B matrices
            self.numSymbols = length(symvar(X));
            [A,B] = self.decompose(X);
            L = size(H,1)*size(A,2);
            Ht = zeros(L,2*size(A,3));
            for i = 1:size(A,3)
                Ht(:,2*(i-1)+1) = reshape(H*A(:,:,i),[],1);
                Ht(:,2*(i-1)+2) = 1i*reshape(H*B(:,:,i),[],1);
            end

            % Convert to real in real out matrix
            Ht_I = real(Ht);
            Ht_Q = imag(Ht);
            Ht = cat(3,Ht_I,Ht_Q);
            Ht = permute(Ht,[3 1 2]);
            Ht = reshape(Ht,[],size(Ht,3));
            [self.Q,self.R] = qr(Ht);
        end
        function X = process(self, Y)
            Y = Y(:);
            Y = [real(Y.'); imag(Y.')];
            Y = Y(:);
            A = self.Q'*Y;
            R = self.R;
            A = A(1:(2*self.numSymbols));
            R = self.R(1:(2*self.numSymbols),:);
            A = rref([R, A]);
            X = real(A(:,end));
            X = complex(X(1:2:end),X(2:2:end));
        end
    end
end