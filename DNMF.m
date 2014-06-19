function [D X iter term] = DNMF(Y, N_samples, R,alpha,D,X,outmid,plotmode,imgwidth)
% this implement the version of DNMF without the penalty term of Xt
%
%[D X iter term] = DNMF(Y, N_samples, R,alpha,D,X,outmid,plotmode,imgwidth)
% the implementation of discriminative NMF (DNMF) 
%
% Input:
%        Matrix Y(M*N,M is the dimension of eDdh sample, N = sum_l{N_l},each
% 		 N_l represents the number of samples in class l),
%        Array N_samples(Number of samples in each class),
%        R(dictionary size of each class),
%        optimization weight alpha
%		 D, X: initialized dictionary and code (fill [] if not have)
%        outmid: whether output the results every 20 updating steps
%		 plotmode: 1-> plot in white background and black content
%				   2-> plot in black background and white content
%		 imgwidth: the width of each image
%
% Output:
%         Discriminative Basis Matrix 'D'(M*Rd),
%         Tolerate Basis Matrix 'Dd'(M*Rt),
%         Coefficient Matrix 'X'(R*N),
%		  number of iteration before convergence 'iter'
%		  the three terms in cost function after converges 'term'
%
% 
%
%
%
%
%% Parameter Settings
L = length(N_samples);
[M, N] = size(Y);
fprintf('RC=%d\talpha=%.3f\n',R,alpha);


maxiter = 300;
c = 1e-9;  % safety parameter
objhistory = 0;

%initialization
Y = mat2cell(Y,M,N_samples);
if isempty(D)||isempty(X)
    [D, X] = InitAS(Y,M,N_samples,R);
end

% Division into cells
X = mat2cell(X,R,N_samples);
D = mat2cell(D,M,ones(L,1)*R);
alpha = alpha/((L-1)*R);
for i = 1:L
    normYl(i) = norm(Y{i})^2;
end

%% Main Iteration
for iter=1:maxiter
    sum_D = zeros(M,R);
    for i = 1:L
        sum_D = sum_D + D{i};
    end
    
    for cid = 1:L % cid is the class id
        
        Y_l = Y{cid};
        S_l = X{cid};
        D_l = D{cid};
        %Update S_l
        S_l = S_l.*(D_l'*Y_l+c)./(D_l'*D_l*S_l+c);
        
        % Update Dd
        % Normalization
        normA_l = sqrt(sum(D_l.^2));%1*RC
        D_l = D_l./(ones(M,1)*normA_l);%M*RC
        S_l = S_l.*(normA_l'*ones(1,N_samples(cid)));%R*N
        
        sum_DdnoL = sum_D - D{cid};
        Diag = diag(diag(sum_DdnoL'*D_l));
        NJDd = Y_l*S_l'/normYl(cid)+ alpha*(D_l*Diag);     %negative derivative of J to Dd
        PJDd = D_l*S_l*S_l'/normYl(cid)+ alpha*sum_DdnoL; %positive derivative of J to Dd
        D_l = D_l.*(NJDd+c)./(PJDd+c);
        
        % Cover Original data
        D{cid} = D_l;
        X{cid} = S_l;
    end
    
    
    % Calculate error, terminate condition
    [objv,term] = OBJ(Y,D,X,alpha,normYl);
    if(outmid)
        if(mod(iter,20)==0)
            fprintf('[%d]:terms:',iter);    fprintf('%f\t',term(1),term(2));  fprintf('\n');
        end
    end
    
    if(abs(objv-objhistory(end))<abs(5e-4*objhistory(end)))
        if(plotmode)   
            Plotdic(D,X,plotmode,imgwidth);
        end
        if(outmid)
            fprintf('------Converge @ [%d]-------\n obj:%f\t terms:',iter,objv);
            fprintf('%.2f\t',term); fprintf('\n');
        end
        break;
    end
    objhistory = [objhistory objv];
end
end

function [objv,term] = OBJ(Y,D,X,alpha,YNorm)
objv = 0;
term = zeros(1,2);
L = length(D);
for l = 1:L
    term(1) = term(1) + 0.5*sum(sum((Y{l} - D{l}*X{l}).^2))/YNorm(l);
    term(2) = term(2) + alpha*discriminative_cost(D,l);
end
objv = objv + sum(term);
end


function v = discriminative_cost(D,l)
v = 0;
for j = (l+1):length(D)
    for r = 1:size(D{l},2)
        %         for rb = 1:size(A{j},2)
        %             v = v+sum(sum(A{j}(:,rb)'*A{l}(:,r)))/norm(A{j}(:,rb))/norm(A{l}(:,r));
        %         end
        % because norm(A{j}(:,r)) ¡Ö 1, substitute it to 1 to speed up
        v = v + sum(sum(sum(D{j},2)'*D{l}(:,r)));
    end
end
end

function Plotdic(D,X,plotmode,imgwidth)
WI = []; WN = []; RI = size(D{1},2); RN = size(Dt{1},2);
for i = 1:length(D)
    WI = [WI D{i}]; 
end
figure(8);
switch plotmode
    case 1
        visual(WI,1,RI,imgwidth);
    case 2
        showPatches(WI,RI);
end

end