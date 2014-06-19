
load('Data\ORL\ORL_32x32.mat')
% Scale the features (pixel values) to [0,1]
%===========================================
minfea = min(fea);
fea = fea - ones(size(fea,1),1)*minfea;
maxfea = max(fea);
fea = (fea*255)./(ones(size(fea,1),1)*maxfea);
%===========================================
datasetname = 'ORL';
K= 40;
% n_outlier = 1;%#outlier per class
% n_train_eachclass = 8-n_outlier;
n_train_eachclass = 8;
load(['Data\ORL\' num2str(n_train_eachclass) 'Train\5.mat']);
outlier_idx = [];

train_s = fea(trainIdx,:)';
train_l = gnd(trainIdx);
test_s = fea(testIdx,:)';
test_l = gnd(testIdx);

N_subsamples = n_train_eachclass*ones(1,K);

R = 6; 
RC = 5;
exception_ratio = (R-RC)/n_train_eachclass;
alpha = [  0.2 ];% 0.02:0.03:0.1]; 
beta = [  2];% 0.5 0.7 1];
svm_mode = 'g';
classifier = 'knn';

LR = length(R); La = length(alpha);
M = size(fea,2);
N = K*n_train_eachclass;
KNNK = 1;
ct = 1;
As = zeros(1,ct); Bs = zeros(1,ct);Cs = zeros(1,ct);Ds = zeros(1,ct);

for it = 1:ct
    Main;
end 
% As = mean(As)
% Bs = mean(Bs)
%Cs = mean(Cs)
% Ds = mean(Ds)
