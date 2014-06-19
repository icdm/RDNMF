function plotClassPoints(A,Label,legendflag)
% plot sample points (columns) of each class in A, NA is number of points
% in each class

if ~exist('legendflag','var')
    legendflag=1;
end

load colorline.mat
[NA,classLabel]=labelInfo(Label);
leg=cell(1,length(NA));
for i=1:length(NA)
    coloridx=mod(i,16);
    if coloridx==0
        coloridx=16;
    end
    
    idx=find(Label==classLabel(i));
    Ak=A(:,idx);
    
    if size(A,1)==1
        plot(idx',Ak',...
            markers{coloridx},'Color',colors(coloridx,:)); hold on;
    elseif size(A,1)==2
        plot(Ak(1,:)',Ak(2,:)',...
            markers{coloridx},'Color',colors(coloridx,:)); hold on;
    else
        plot3(Ak(1,:)',Ak(2,:)',Ak(3,:)',...
            markers{coloridx},'Color',colors(coloridx,:)); hold on;
    end
    leg{i}=num2str(i);
end

if legendflag
    legend(leg,'Location','best');
end
% title(); 
hold off;

% maxscrn;%最大化窗口
% setplot;%加粗字体，线和标号
