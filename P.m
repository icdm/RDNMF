function [  ] = P( varargin )
%Draw the dictionary

if nargin == 2
    imshow(varargin{1}{varargin{2}},[0 max(max(varargin{1}{varargin{2}}))]);
    colormap(gray);
else if nargin == 1
         imagesc(varargin{1},[0 max(max(varargin{1}))]); colormap(gray);
%          imagesc(varargin{1}); colormap(gray);
    else
        fprintf('input args should be less than 3');
    end
end

% if nargin == 2
%     imagesc(varargin{1}{varargin{2}},[0 1]);colormap(gray);
% else if nargin == 1
%         imagesc(varargin{1},[0 1]); colormap(gray);
%     else
%         fprintf('input args should be less than 3');
%     end
% end
end

