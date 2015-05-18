function [Lcomplete,par]= tpsSymPts2(srcVertices, tgtVertices, symPts1, symPts2)
% Returns the coefficients of the thin-plate-splines deformation function
% constrained by reflection symmetry about the plane defined by the normal
% 'n' and a point on the plane 'm' and a pair of pts responsible for that
% symmetry
% Input:
% srcVertices - #Pts x 3 matrix of src vertex coordinates
% tgtVertices - #Pts x 3 matrix of target vertex coordinates
% symPts - #symmetric pairs x 3 matrix of point coordinates that are
% responsible for that symmetry plane
% n - 3 x 1 normal vector
% m - 3 x 1 coordinate of the point on the plane
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning('depreciated tpsSymPts2');
% wSym = 10;
wCorr = 1;
wTps = 1;
lambda = 0.1;
regularization = 0.1;

N = size(srcVertices,1);
% S = size(symPts,1);
numSymPts =size(symPts1,1);

%% Construct P
P = [ones(N,1) srcVertices];


%% Construct K
K = zeros(N);
for i=1:N
    for j=i:N
        K(i,j) = U(srcVertices(i,:)',srcVertices(j,:)');
        K(j,i) = K(i,j);
    end
%     K(j,i) = K(i,j);
end
Winv = 1*eye(N);
K = K+N*regularization*Winv;

%% Construct the basic matrix
M = [wCorr*P wCorr*K; zeros(4) wTps*P']; %P'
L = kron(eye(3),M);

%% Construct the output vector
y = wCorr*vec([tgtVertices;zeros(4,3)]);

%% Construct reflexive transformation matrices
% A = eye(3)-2*n*n';
% t = 2*n*n'*m;
for i=1:numSymPts
    n = symPts2(i,:)'-symPts1(i,:)';
    n = n/(norm(n,2)+0.001);
    A{i,1} = eye(3)-2*n*n';
    m = (symPts2(i,:)'+symPts1(i,:)')/2;
    t{i,1} = 2*n*n'*m;
end

%% Add extra constraints for each symmetric point 
Pextra1 = [ones(numSymPts,1) symPts1];
Kextra1 = zeros(numSymPts,N);
for i=1:numSymPts
    for j=1:N
        Kextra1(i,j) = U(symPts1(i,:)',srcVertices(j,:)');
    end
end

% reflectedSymPts = (A*symPts'+repmat(t,1,S))';
Pextra2 = [ones(numSymPts,1) symPts2];
Kextra2 = zeros(numSymPts,N);
for i=1:numSymPts
    for j=1:N
        Kextra2(i,j) = U(symPts2(i,:)',srcVertices(j,:)');
    end
end

% Lextra = size(3*S,3*(4+N));
wSym = lambda*wCorr*N/(numSymPts+0.001);
Lextra = [];
for i=1:numSymPts
    Mextra = A{i,1}*kron(eye(3),[Pextra1(i,:) Kextra1(i,:)])-kron(eye(3),[Pextra2(i,:) Kextra2(i,:)]);
    Lextra = [Lextra;wSym*Mextra];
%     Lextra(3*i-2:3*i,:) = Mextra;
end

% yextra = zeros(3*S,1);
yextra = [];
for i=1:numSymPts
    yextra = [yextra;-wSym*t{i,1}];
end

%% Solve the system of linear equations
Lcomplete = [L; Lextra];
ycomplete = [y; yextra];

par = Lcomplete\ycomplete;
% par = L\y;

end












