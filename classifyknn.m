function [ acc ] = classifyknn(Ztrain, TrainY, Ztest, TestY, classifier,svm_mode,K)
%[ acc ] = classify(Ztrain, TrainY, Ztest, TestY, classifier,K)
%   classify according to code
acc = cellfun(@(Ztrain,Ztest) classifyMethod(Ztrain',TrainY,Ztest',TestY,classifier,svm_mode,K),Ztrain,Ztest,'UniformOutput',false);

end

function Accuracy = classifyMethod(Ztrain, TrainY, Ztest, TestY, classifier, kerneltype, K)
% Ztrain = Ztrain'; Ztest = Ztest';
if (strcmp(classifier,'svm')||strcmp(classifier,'SVM'))
    if kerneltype == 'g'
        model = svmtrain(TrainY,Ztrain, '-c 1 -g 3 -b 1 -q 1');
        [~,Accuracy,~] = svmpredict(TestY,Ztest,model, '-b 1');
    else
        model = svmtrain(TrainY,Ztrain,'-q 1');
        [~,Accuracy,~] = svmpredict(TestY,Ztest,model);
    end
else
    if (strcmp(classifier,'knn')||strcmp(classifier,'KNN'))
        predictlabel = knnclassify(Ztest,Ztrain,TrainY,K);
        Accuracy = length(find(predictlabel==TestY))/length(TestY)*100;
        fprintf(['Accuracy = ' num2str(Accuracy) '\n']);
    else
        fprintf('undefined classifier');
    end
end
end