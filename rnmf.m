function [ F,G ] = rnmf( X,r )
%RNMF Summary of this function goes here
%   Detailed explanation goes here

[m,n] = size(X);
F = rand(m,r);
G = rand(r,n);
maxIter = 300;
eps = 1e-5;

costold = 1;
for t=1:maxIter
    D = zeros(n,1);
    for i=1:n
        D(i)=norm(X(:,i)-F*G(:,i));
    end
    cost = sum(D);
    if(abs(cost-costold)/costold<1e-3)
        disp(['stop at ' num2str(t) '-th iteration.']);
        break;
    end
    costold=cost;
    D = diag(1./D);
    F=F.*(X*D*G')./(F*G*D*G'+eps);
    G=G.*(F'*X*D)./(F'*F*G*D+eps);
end
if(t==maxIter)
    disp(['stop at ' num2str(maxIter) '-th iteration.']);
end
