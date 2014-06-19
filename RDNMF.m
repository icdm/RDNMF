function [Dd Dt X iter term] = RDNMF(Y, N_samples, R, Rd,alpha,beta,Dd,Dt,X,outmid,plotmode,imgwidth)
%[Dd Dt S iter term] = RDNMF(Y, N_samples, R, Rt,alpha,beta,Dd,Dt,S,outmid,plotmode,imgwidth)
% the implementation of robust discriminative NMF (RDNMF) 
%
% Input:
%        Matrix Y(M*N,M is the dimension of eDdh sample, N = sum_l{N_l},each
% 		 N_l represents the number of samples in class l),
%        Array N_samples(Number of samples in each class),
%        R(number of medial components),
%        Rd(the number of columns in Dd_l),
%        optimization weight alpha,beta
%		 Dd, Dt, X: initialized dictionary and code (fill [] if not have)
%        outmid: whether output the results every 20 updating steps
%		 plotmode: 1-> plot in white background and black content
%				   2-> plot in black background and white content
%		 imgwidth: the width of each image
%
% Output:
%         Discriminative Basis Matrix 'Dd'(M*Rd),
%         Tolerate Basis Matrix 'Dd'(M*Rt),
%         Coefficient Matrix 'X'(R*N),
%		  number of iteration before convergence 'iter'
%		  the three terms in cost function after converges 'term'
%
% 
%
%
%% Parameter Settings
L = length(N_samples);
RN = R-Rd;
[M, N] = size(Y);
fprintf('R=%d\tRC=%d\talpha=%.3f\tbeta=%.3f\n',R,Rd,alpha,beta);

maxiter = 500;
c = 1e-9;  % safety parameter
objhistory = 0;

%initialization
Y = mat2cell(Y,M,N_samples);
if isempty(Dd)||isempty(Dt)||isempty(X)
    [Dd Dt X] = InitAS(Y,M,N_samples,R,Rd);
end

% Division into cells
X = mat2cell(X,[Rd RN],N_samples);
Dd = mat2cell(Dd,M,ones(L,1)*Rd);
Dt = mat2cell(Dt,M,ones(L,1)*RN);

%Parameter adjusting
alpha = alpha/((L-1)*Rd);
beta = beta/RN/sqrt(N);
for cid = 1:L
    normYl(cid) = norm(Y{cid})^2;
end

%% Main Iteration
for iter=1:maxiter
    sumDd = zeros(M,1);
    for cid = 1:L
        sumDd = sumDd + sum(Dd{cid},2);
    end
    for cid = 1:L
        Y_l = Y{cid};
        Xd_l = X{1,cid};  Xt_l = X{2,cid};  X_l = [Xd_l;Xt_l];
        Dd_l = Dd{cid};  Dt_l = Dt{cid};  D_l = [Dd_l Dt_l];
        
        %% Update Xd_L
        Xd_l = Xd_l.*(Dd_l'*Y_l)./(Dd_l'*D_l*X_l+c);
        
        %% Update Xt_L
        %normalize Xt_l
        normXt_l = sqrt(sum(Xt_l'.^2))';
        Xt_l = Xt_l./(normXt_l*ones(1,N_samples(cid)));
        Dt_l = Dt_l.*(ones(M,1)*normXt_l');
        D_l = [Dd_l Dt_l]; X_l = [Xd_l;Xt_l];
        % update Xt_l each row
        Diag = diag(sum(Xt_l,2));%RN*RN
        NJXt = Dt_l'*Y_l/normYl(cid)+beta*(Diag*Xt_l);
        PJXt = Dt_l'*D_l*X_l/normYl(cid)+beta;
        Xt_l = Xt_l.*NJXt./(PJXt+c);
        
        %% Update Dd_l
        %normalize Dd_l
        normDd_l = sqrt(sum(Dd_l.^2));%1*Rd
        Dd_l = Dd_l./(ones(M,1)*normDd_l+c);%M*Rd
        Xd_l = Xd_l.*(normDd_l'*ones(1,N_samples(cid)));
        D_l = [Dd_l Dt_l];X_l = [Xd_l;Xt_l];
        
        %update Dd_l each column
        sumDdj_L = sumDd - sum(Dd{cid},2);
        Diag = sumDdj_L'*Dd_l;
        Diag = diag(Diag);
        NJDd = Y_l*Xd_l'/normYl(cid) + alpha * Dd_l*Diag;
        PJDd = D_l*X_l*Xd_l'/normYl(cid)+alpha * sumDdj_L*ones(1,Rd);
        Dd_l = Dd_l.*NJDd./(PJDd+c);
        D_l = [Dd_l Dt_l];
        
        %% Update Dt_l
        Dt_l = Dt_l.*(Y_l*Xt_l')./(D_l*X_l*Xt_l'+c);
        
        % Cover Original data
        Dd{cid} = Dd_l; Dt{cid} = Dt_l;
        X{1,cid} = X_l(1:Rd,:); X{2,cid} = X_l(Rd+1:R,:);
        
    end
    
    % Calculate error, terminate condition
    [objv,term] = OBJ(Y,Dd,Dt,X,alpha,beta,normYl);
    if(outmid)
        if(mod(iter,20)==0)
            fprintf('[%d]:terms:',iter);    fprintf('%f\t',term(1),term(2),term(3));  fprintf('\n');
        end
    end
    
    if(abs(objv-objhistory(end))<abs(1e-4*objhistory(end)))
        if(plotmode)
            Plotdic(Dd,Dt,X,plotmode,imgwidth);
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

function [objv,term] = OBJ(Y,Dd,Dt,X,alpha,beta,normY)
term = zeros(1,3);
L = length(Dd);
for l = 1:L
    term(1) = term(1) + 0.5*sum(sum((Y{l} - [Dd{l} Dt{l}]*[X{1,l};X{2,l}]).^2))/normY(l);
    term(2) = term(2) + alpha*discriminative_cost(Dd,l);
    term(3) = term(3) + beta*sum(sum(X{2,1},2)./sqrt(sum(X{2,1}'.^2))');
end
objv = sum(term);
end

function v = discriminative_cost(D,l)
v = 0;
for j = (l+1):length(D)
    for r = 1:size(D{l},2)
        v = v + sum(sum(sum(D{j},2)'*D{l}(:,r)));
    end
end
end

function Plotdic(Dd,Dt,X,plotmode,imgwidth)
WI = []; WN = []; Rt = size(Dd{1},2); RN = size(Dt{1},2);
% show the dictionaries of at most 4 classes
show_L = min(4,length(Dd));
show_Dd_components = min(4,size(Dd{1},2));
show_Dt_components = min(4,size(Dt{1},2));
for i = 1:show_L
    WI = [WI Dd{i}(:,1:show_Dd_components)]; WN = [WN Dt{i}(:,1:show_Dt_components)];
end
figure(8);
switch plotmode
    case 1
        subplot(211);    visual(WI,1,show_Dd_components,imgwidth);
        subplot(212);    visual(WN,1,show_Dt_components,imgwidth);
    case 2
        subplot(2,1,1);    showPatches(WI,show_Dd_components);
        subplot(2,1,2);    showPatches(WN,show_Dt_components);
end
end