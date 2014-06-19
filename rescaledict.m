function [A, S] = rescaledict(A,S)
% RESCALEDICT  Rescale dictionary.
%
% Author: Steve Tjoa
% Institution: University of Maryland (Signals and Information Group)
% Created: July 1, 2009
% Last modified: July 2, 2009
%
% This code was written during the workshop on Music Information Retrieval
% at the Center for Computer Research in Music and Acoustics (CCRMA) at
% Stanford University.

M = size(A,1);
N = size(S,2);
if nargin==2
%     K = size(A,2);
%     
%         for k=1:K
%             g = norm(A(:,k));
%             A(:,k) = A(:,k)./g;
%             S(k,:) = S(k,:).*g;
%         end
g = sqrt(sum(A.^2));
A = A./(ones(M,1)*g);
S = S./(g'*ones(1,N));
end
end
