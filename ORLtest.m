
load('Data\ORL\ORL_32x32.mat')
% Scale the features (pixel values) to [0,1]
%===========================================
% Same preprocessing as Stan Li et al
minfea = min(fea);
fea = fea - ones(size(fea,1),1)*minfea;
maxfea = max(fea);
fea = (fea*255)./(ones(size(fea,1),1)*maxfea);
%===========================================
datasetname = 'ORL';
K= 40;
n_train_eachclass = 8;
load(['Data\ORL\' num2str(n_train_eachclass) 'Train\5.mat']);
outlier_idx = [];

train_s = fea(trainIdx,:)';
train_l = gnd(trainIdx);
test_s = fea(testIdx,:)';
test_l = gnd(testIdx);

N_subsamples = n_train_eachclass*ones(1,K);

R = 6; 
Rd = 5;
exception_ratio = (R-Rd)/n_train_eachclass;
alpha = [  0.08 ];% 0.02:0.03:0.1]; 
beta = [ 1.25];% 0.5 0.7 1];

LR = length(R); La = length(alpha);
M = size(fea,2);  N = K*n_train_eachclass;
KNNK = 1;
ct = 2;

for it = 1:ct
    Main;
end 

fprintf('The recognition rate of KNN (without feature extraction) is %.2f\n', mean(res_KNN))
fprintf('The recognition rate of NMF (without feature extraction) is %.2f\n', mean(res_INMF))
fprintf('The recognition rate of RNMF (without feature extraction) is %.2f\n', mean(res_RNMF))
fprintf('The recognition rate of DNMF (without feature extraction) is %.2f\n', mean(res_DNMF))
fprintf('The recognition rate of RDNMF (without feature extraction) is %.2f\n', mean(res_RDNMF))


