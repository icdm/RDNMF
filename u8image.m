function uint8Im=u8image(Im,lim)
if nargin<2
    lim(1)=min(Im(:));
    lim(2)=max(Im(:));
end

if lim(2)==lim(1)
    uint8Im=repmat(uint8(0),size(Im));
else
    uint8Im=uint8(double(Im-lim(1))*255/double(lim(2)-lim(1)));
end
end