function [s,R,t] = findSimilarityTransform(ptsSrc,ptsTgt)
% Finds similarity trasnformation that maps ptsSrc to ptsTgt
% ptsTgt = s * R * ptsSrc + t;
% Input:
% ptsSrc and ptsTgt are d x n dimensional matrices where d is the dimension
% of the data and n is the number of point correspondences
% Output:
% s - scaling factor
% R - rotation Matrix of dimension d x d
% t - translation vector of dimension d x 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% check dimensions
dcheck = size(ptsSrc)~=size(ptsTgt);
if(dcheck(1)==1)
    error('Data dimensions of ptsSrc and ptsTgt do not match')
elseif(dcheck(2)==1)
    error('The number of points in ptsSrc and ptsTgt do not match')
end

%% get d and n
d = size(ptsSrc,1);
n = size(ptsSrc,2);

%% find centroid
centroidSrc = sum(ptsSrc,2)/n;
centroidTgt = sum(ptsTgt,2)/n;

%% center points around their respective centroids
centeredPtsSrc = ptsSrc - repmat(centroidSrc,1,n);
centeredPtsTgt = ptsTgt - repmat(centroidTgt,1,n);

%% find scaling factor s
S_Src = 0;
S_Tgt = 0;
for i=1:n
    S_Src = S_Src + norm(centeredPtsSrc(:,i),2)^2;
    S_Tgt = S_Tgt + norm(centeredPtsTgt(:,i),2)^2;
end
s = sqrt(S_Tgt/S_Src);
if(isnan(s))
    error('s is NaN')
elseif(isinf(s))
    error('s is Inf')
end

%% find rotation matrix

% find M
M=zeros(d);
for i=1:n
    M = M + centeredPtsTgt(:,i)*centeredPtsSrc(:,i)';
end

% find M
S = (M'*M)^(0.5); 
if(det(M)~=0)
    U = M/S;
else
    error('S Matrix is singular');
end
R=U;

%% find translation vector
t = centroidTgt - s*R*centroidSrc;
















