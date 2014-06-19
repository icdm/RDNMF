function [ acc ] = classifyknn(Ztrain, TrainY, Ztest, TestY, classifier,K)
%[ acc ] = classify(Ztrain, TrainY, Ztest, TestY, classifier,K)
%   classify according to code
acc = cellfun(@(Ztrain,Ztest) classifyMethod(Ztrain',TrainY,Ztest',TestY,classifier,K),Ztrain,Ztest,'UniformOutput',false);

end

function Accuracy = classifyMethod(Ztrain, TrainY, Ztest, TestY, classifier, K)
if (strcmp(classifier,'knn')||strcmp(classifier,'KNN'))
    predictlabel = knnclassify(Ztest,Ztrain,TrainY,K);
    Accuracy = length(find(predictlabel==TestY))/length(TestY)*100;
    fprintf(['Accuracy = ' num2str(Accuracy) '\n']);
else
    fprintf('undefined classifier');
end
end