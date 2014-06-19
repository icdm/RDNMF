function showPatches(P,n,h,datatype)
% each column of P contain a vectorlized patch
% n: # pathes per row
% h: height of patch. for square patch, it can be omitted
% datatype: 'grayR':gray image (default), 'RGB':color image
% examples: showPatches(A,10), showPatches(A,10,8), showPatches(A,10,8,'grayR'),
% Zhenfang Hu. version 2012-2-15
s=size(P,2);
if nargin<2 || isempty(n)
    n=ceil(sqrt(s));
    m=n;
else
    m=ceil(s/n);
end

P=[P zeros(size(P,1),n*m-s,class(P))];
A=mat2cell(P,size(P,1),ones(1,n*m));
A=reshape(A,n,m)';

if nargin<4
    datatype='grayR';
end

switch datatype
    case 'RGB'
        if nargin<3
            h=sqrt(size(P,1)/3);
            w=size(P,1)/3/h;
        else
            w=size(P,1)/3/h;
        end
        A=cellfun(@reshapeRGB,A, 'UniformOutput', false);
        A=cell2mat(A);
        for i=1:3
            B(:,:,i)=blkm(A(:,:,i),{h,w});
        end
    case 'grayR'
        if nargin<3
            h=sqrt(size(P,1));
            w=size(P,1)/h;
        else
            w=size(P,1)/h;
        end
        A=cellfun(@reshapegray,A, 'UniformOutput', false);
        A=cell2mat(A);
        B=blkm(A,{h,w});
end

imshow(uint8(B));

    function y=reshapeRGB(x)
        y=reshape(x,h,w,3);
        y=u8image(y);
    end

    function y=reshapegray(x)
        y=reshape(x,h,w);
        y=u8image(y);
    end

end