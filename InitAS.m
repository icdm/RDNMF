function [AC,varargout] = InitAS(X,M,N_samples,R,varargin)
L = length(N_samples);

%Initialized by Uniform Random
if(nargin==4)
    AC = abs(randn(M,R*L));
    S = abs(randn(R,sum(N_samples)));
    varargout{1} = S;

else if(nargin==5)
        RC = varargin{1};
        RI = R-RC;
        AC = abs(randn(M, RC*L));
        AI = abs(randn(M, RI*L));
        S = abs(randn(R, sum(N_samples)));
        for i=1:L
            Xl = X{i};
            idx = randperm(R);
            AC(:,(RC*(i-1))+(1:RC))=Xl(:,idx(1:RC));
        end
        varargout{1} = AI; varargout{2} = S;
    else
        fprintf('InitAS input parameter err...\n');
    end
end