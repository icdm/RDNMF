function B=blkm(I,Rn,pad)
% I: image/matrix
% Rn{1}: row dir # elements in each region, Rn{2} column dir; if Rn{1} is
% scalar, then every region has the same # elements.
% pad: paded value, defult is 0
% Zhenfang Hu. version 2011-5-17
[N M]=size(I);
if length(Rn{1})==1
    if mod(N,Rn{1})
        disp('blkm no match.'); return;  
    end
    Rn{1}=repmat(Rn{1},1,N/Rn{1});
end
    
if length(Rn)<2 
    if N~=M
        disp('only x Rn for non square matrix'); return;
    end
    Rn{2}=Rn{1};
else
    if mod(M,Rn{2})
        disp('blkm no match.');
        return;  
    end
    Rn{2}=repmat(Rn{2},1,M/Rn{2});
end

rRs=length(Rn{1});
cRs=length(Rn{2});

if nargin<3
    pad=0;
end

B=pad*ones(N+rRs-1,M+cRs-1,class(I));
C=mat2cell(I,Rn{1},Rn{2});

rends=cumsum(Rn{1})+[0:rRs-1];
cends=cumsum(Rn{2})+[0:cRs-1];
rbegs=rends-Rn{1}+1;
cbegs=cends-Rn{2}+1;

for r=1:rRs
    for c=1:cRs
        B(rbegs(r):rends(r),cbegs(c):cends(c))=C{r,c};
    end 
end

