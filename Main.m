classifier = 'knn';


fprintf('---------DIRECT KNN---------\n');
predictlabel = knnclassify(test_s',train_s',train_l,KNNK);
A = length(find(predictlabel==test_l))/length(test_l)*100;
fprintf('Accuracy = %.4f\n',A);
eval([datasetname '.knn = A;']);
res_KNN(it) = A;




fprintf('-----------INMF-------------\n');
eval([datasetname '.RC = RC1;']);
[Anmf, Ztrain, Ztest] = Imodel(train_s,test_s,N_subsamples,K,'Inmf',exception_ratio,RC);
fprintf('R=');fprintf('%d\t\t',RC1);
Acc = arrayfun(@(Ztrain,Ztest) classifyknn(Ztrain, train_l, Ztest, test_l, classifier,KNNK),...
    Ztrain,Ztest,'UniformOutput',false);
A = [];
for i = 1: length(Acc) % combination of R
      A = [A Acc{i}{1}];
end
res_INMF(it) = A(1);


fprintf('-----------RNMF-------------\n');
RC1 = RC;
[Anmf, Ztrain, Ztest] = Imodel(train_s,test_s,N_subsamples,K,'Rnmf',exception_ratio,RC);
Acc = arrayfun(@(Ztrain,Ztest) classifyknn(Ztrain, train_l, Ztest, test_l, classifier,KNNK),...
    Ztrain,Ztest,'UniformOutput',false);
A = [];
for i = 1: length(Acc) % combination of R
      A = [A Acc{i}{1}];
end

fprintf('R=');fprintf('%d\t\t',RC1);
fprintf('RNMF Accuracy : %.2f\n',A);
res_RNMF(it) = A(1);



% GPNMF2
fprintf('---------- DNMF -----------\n');
[A, Ztrain, Ztest] = Imodel(train_s,test_s,N_subsamples,K,'DNMF',exception_ratio,RC,alpha);
fprintf('R=');fprintf('%d\t\t',RC1);
fprintf('alpha=');fprintf('%.3f\t\t\n',alpha);
Acc = arrayfun(@(Ztrain,Ztest) classifyknn(Ztrain, train_l, Ztest, test_l, classifier,KNNK),...
    Ztrain,Ztest,'UniformOutput',false);
A_DNMF = [];
for i = 1: length(Acc) % combination of R,RC
    A_DNMF = [A_DNMF Acc{i}{1}];
end
res_DNMF(it) = A_DNMF(1);



fprintf('---------- RDNMF -----------\n');
RC1 = RC*ones(1,LR);
[AI, Ztrain, Ztest,AN,exception_id] = arrayfun(@(R,RC) Imodel(train_s,test_s,N_subsamples,K,'RDNMF',exception_ratio,R,RC,alpha,beta), R,RC1,'UniformOutput',false);
fprintf('R=');fprintf('%d\t\t',R);
fprintf('RC=');fprintf('%d\t\t',RC1);fprintf('\n');
fprintf('alpha=');fprintf('%.3f\t\t',alpha);
fprintf('beta=');fprintf('%.3f\t',beta);fprintf('\n');
Acc = cellfun(@(Ztrain,Ztest) classifyknn(Ztrain, train_l, Ztest, test_l, classifier,KNNK),...
    Ztrain,Ztest,'UniformOutput',false);
A_ARDNMF = zeros(LR,La*length(beta));
for i = 1: length(Acc) % combination of R,RC
    for j = 1: length(Acc{1}) % combination of alpha, beta
        A_ARDNMF(i,j) = Acc{i}{j}(1);
    end
end
fprintf('%.4f\t',A_ARDNMF); fprintf('\n');
res_RDNMF(it) = A_ARDNMF(1);


