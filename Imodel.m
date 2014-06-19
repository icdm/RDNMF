function [ Dict,Ztrain,Ztest,varargout ] = Imodel( train_s,test_s,N_samples,K,modeltype,exception_percent,varargin)
%function [ A,Ztrain,Ztest,varargout ] = Imodel( train_s,test_s,N_samples,K,modeltype,varargin)
%   Get the learnt dictionary, feature of training and testing data of our proposed method
%	Input:  train_s: training set,
%			test_s:	testing set,
%			N_samples: number of samples in each class
%			K: number of classes
%			modeltype: 
%
%
%
%
%
switch modeltype
    case 'Inmf'
        RC = varargin{1};
        Dict = arrayfun(@(RC) NMFdict(train_s,N_samples,K,RC), RC,'UniformOutput',false);
        [Dict,Ztrain,Ztest] = arrayfun(@(Anmf) getcode(train_s,test_s,Anmf), Dict,'UniformOutput',false);
        
    case 'Onmf'
        RC = varargin{1};
        Dict = arrayfun(@(RC) nmf(train_s,RC,'euc'),RC*K,'UniformOutput',false);
        [Dict,Ztrain,Ztest] = arrayfun(@(Anmf) getcode(train_s,test_s,Anmf), Dict,'UniformOutput',false);
        
    case 'Rnmf'
        RC = varargin{1};
        Dict = arrayfun(@(RC) RNMFdict(train_s,N_samples,K,RC), RC,'UniformOutput',false);
        [Dict,Ztrain,Ztest] = arrayfun(@(Anmf) getcode(train_s,test_s,Anmf), Dict,'UniformOutput',false);
        
    case 'RDNMF'
        M = size(train_s,1);
        R = varargin{1}; RC = varargin{2}; alpha = varargin{3}; beta = varargin{4};
        
        Lalpha = length(alpha);
        Lbeta = length(beta);
        alpha = reshape(repmat(alpha,Lbeta,1),1,Lalpha*Lbeta);  beta = repmat(beta,1,Lalpha);
        
        [Dict,AN,~,~,~] = arrayfun(@(alpha,beta) RDNMF(train_s,N_samples,R,RC,alpha,beta,[],[],[],1,1,32),alpha,beta,'UniformOutput',false);
        [Dict Ztrain Ztest] = arrayfun(@(AI) getcode(train_s, test_s, AI),Dict,'UniformOutput',false);
        
    case 'DNMF'
        M = size(train_s,1);
        RC = varargin{1}; alpha = varargin{2};
        
        LRC = length(RC);Lalpha = length(alpha);
        RC2 = reshape(repmat(RC,Lalpha,1),1,[]);
        alpha2 = repmat(alpha,1,LRC);
        
        Dict = arrayfun(@(RC,alpha) DNMF(train_s,N_samples,RC,alpha,[],[],1,0,32),RC2,alpha2,'UniformOutput',false);
        [Dict Ztrain Ztest] = cellfun(@(A) getcode(train_s, test_s, A),Dict,'UniformOutput',false);
        
end
exception_id = cellfun(@(Dict,Z)findexception(train_s, Dict, Z,exception_percent),Dict,Ztrain,'UniformOutput',false);
if(strcmp(modeltype,'RDNMF')||strcmp(modeltype,'DNMF'))
    varargout{2} = exception_id;
else
    varargout{1} = exception_id;
end
end

function Anmf = NMFdict(train_s,N_samples,K,RC)
Anmf = [];
for i = 1:K
    Y = train_s(:,(1:N_samples(i))+sum(N_samples(1:(i-1))));
    [Ainmf,X] = nmf(train_s(:,(1:N_samples(i))+sum(N_samples(1:(i-1)))),RC,'euc');
    Anmf = [Anmf Ainmf];
end
end

function Rnmf = RNMFdict(train_s,N_samples,K,RC)
Rnmf = [];
for i = 1:K
    Y = train_s(:,(1:N_samples(i))+sum(N_samples(1:(i-1))));
    [Arnmf,X] = rnmf(Y,RC);
    Rnmf = [Rnmf Arnmf];
end
end

function [ Dic,Ztrain,Ztest ] = getcode( TrainX, TestX, D )
%get the feature(code) of each sample in TrainX given dictionary D
% Concatenate the dictionary -> final dictionary 'Dic'
% and solve the samples in TrainX by NNLS
Dic = [];
if(iscell(D{1}))
    K = size(D{1},2);
    for k = 1:K;
        Dic = [Dic D{1}{k}];
    end
else
    K = size(D,2);
    for k = 1:K;
        Dic = [Dic D{k}];
    end
end
R = size(Dic,2);
Ntrain = size(TrainX,2);
Ntest = size(TestX,2);
Ztest = zeros(R,Ntest); Ztrain = zeros(R,Ntrain);
for sidx = 1:Ntrain
    Ztrain(:,sidx) = lsqnonneg(Dic,TrainX(:,sidx));
end

for sidx = 1: Ntest
    Ztest(:,sidx) = lsqnonneg(Dic,TestX(:,sidx));
end

end


function [exceptionidx] = findexception(TrainX, Dic, TrainZ,exception_percent)
Error = sum((TrainX-Dic*TrainZ).^2);
[~,pos] = sort(Error,'descend');
n_exception = ceil(exception_percent*size(TrainX,2));%select the biggest 1% as exception
exceptionidx = pos(1:n_exception);
end
