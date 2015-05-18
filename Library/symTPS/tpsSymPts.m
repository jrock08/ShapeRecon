function [Lcomplete,par]= tpsSymPts(srcVertices, tgtVertices, symPts1, symPts2, controlPts)
% Returns the coefficients of the thin-plate-splines deformation function
% constrained by reflection symmetry about the plane defined by the normal
% 'n' and a point on the plane 'm' and a pair of pts responsible for that
% symmetry
% Input:
% srcVertices - #Pts x 3 matrix of src vertex coordinates
% tgtVertices - #Pts x 3 matrix of target vertex coordinates
% symPts - #symmetric pairs x 3 matrix of point coordinates that are
% controlPts - #controlPts x 3 matrix of radial basis centers
% responsible for that symmetry plane
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = size(srcVertices,1);
numSymPts =size(symPts1,1);
numControlPts = size(controlPts,1);

%% Parameters
wCorr = 1;
wTps = 1;
lambda = 2;

if(numSymPts==0)
    regularization = 0.1;
else
    regularization = 0.0001;
end


if(N~=numControlPts)
    error('number of control points should be equal to the number of correspondences');
end

%% Construct P
P = [ones(N,1) srcVertices];


%% Construct K
K = pdist2(srcVertices,controlPts);
K = K.^3;

Winv = 1*eye(N);
K = K+N*regularization*Winv;

%% Construct the basic matrix
M = [wCorr*P wCorr*K; zeros(4) wTps*P']; %P'
L = kron(eye(3),M);

%% Construct the output vector
y = wCorr*vec([tgtVertices;zeros(4,3)]);

if(numSymPts~=0)

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
    Kextra1 = pdist2(symPts1,controlPts);
    Kextra1 = Kextra1.^3;

    % reflectedSymPts = (A*symPts'+repmat(t,1,S))';
    Pextra2 = [ones(numSymPts,1) symPts2];
    Kextra2 = pdist2(symPts2,controlPts);
    Kextra2 = Kextra2.^3;

    wSym = lambda*wCorr*N/(numSymPts+0.001);
    Lextra = [];
    for i=1:numSymPts
        Mextra = A{i,1}*kron(eye(3),[Pextra1(i,:) Kextra1(i,:)])-kron(eye(3),[Pextra2(i,:) Kextra2(i,:)]);
        Lextra = [Lextra; wSym*Mextra];
    end

    yextra = [];
    for i=1:numSymPts
        yextra = [yextra;-wSym*t{i,1}];
    end
else
    Lextra = [];
    yextra = [];
end

%% Solve the system of linear equations
Lcomplete = sparse([L; Lextra]);
ycomplete = [y; yextra];

par = Lcomplete\ycomplete;
end












