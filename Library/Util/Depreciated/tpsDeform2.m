function deformedVertices = tpsDeform2(vertex, srcPair, par)
% Input - 
% vertex - 3 x #numVertices matrix
warning('tpsDeform2 is depreciated.');

N=size(srcPair,1);
M = size(vertex, 2);

%% Compute K
K=zeros(M,N);
for j=1:M
    for i=1:N
        K(j,i) = U(vertex(:,j),srcPair(i,:)');
    end
end

%% Compute P
P = [ones(M,1) vertex'];

%% Compute deformation
defVertex = kron(eye(3),[P K])*par;
deformedVertices = reshape(defVertex,M,3);

