% load ('Data\wine.data');
% save('wine.mat','wine');
% load('Data\car.data');
% M =6; K=4;
% n_each = [1210 384 69 65];
% pointer = 1;
% for i=1:K
%     labels((1:n_each(i))+sum(n_each(1:(i-1)))) = i;
% end
% fea = zeros(6,sum(n_each));
% pointer = ones(K,1);
% for i=1:sum(n_each)
%     i
%     l = car(i,7);
%     fea(:,pointer(l)+sum(n_each(1:(l-1)))) = car(i,1:6)';
%     pointer(l) = pointer(l)+1;
% end
% save('Data\car.mat','fea','labels');

load('Data\car.mat');
n_each = [1210 384 69 65];
M =6; K=4;
% fea = fea./(ones(M,1)*sqrt(sum(fea.^2,1)));
fea = fea./(max(fea,[],2)*ones(1,1728));
N_select_train = 40;
train_s = []; test_s = []; train_l = []; test_l = [];
for k=1:K
    idx = randperm(n_each(k));
    train_s = [train_s fea(:,sum(n_each(1:(k-1)))+idx(1:N_select_train))];
    test_s = [test_s fea(:,sum(n_each(1:k-1))+idx((N_select_train+1):n_each(k)))];
    train_l = [train_l; k*ones(N_select_train,1)];
    test_l = [test_l; k*ones(n_each(k)-N_select_train,1)];
end
save('cars.mat','train_s','train_l','test_s','test_l')
N_subsamples = ones(K,1)*(N_select_train);

%% INITIALIZATION
%Parameter Setting
datasetname = 'cars';
R = [8]; 
RC = 4;
alpha = [0.05];% 0.02:0.03:0.1]; 
beta = [1.5];% 0.7:0.1:0.9];
classifier = 'knn';
svm_mode = 'd';
KNNK = 1;
LR = length(R);La = length(alpha);
eval([datasetname '.R = R;' datasetname '.alpha = alpha;' datasetname '.beta=beta;']);
exception_ratio = 0.1;
ct = 1;
ntest = 1;
As = zeros(1,ntest*ct); Bs = zeros(1,ntest*ct);Cs = zeros(1,ntest*ct);
Ds = zeros(1,ntest*ct);Es = zeros(1,ntest*ct);Fs = zeros(1,ntest*ct);
for it = 1:ct
    Main;
    A_ARDNMF
end
mean(As)
mean(Bs)
mean(Cs)
mean(Ds)
mean(Es)
mean(Fs)
% mean(Gs)
mean(Hs)
mean(Is)

