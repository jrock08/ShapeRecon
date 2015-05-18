function deformedVertices = tpsDeform(vertex, controlPts, par)
% Input - 
% vertex - 3 x #numVertices matrix
% controlPts - 3 x #numControlPts matrix

N=size(controlPts,2);
M = size(vertex, 2);

%% Compute K
if(isempty(vertex))
  deformedVertices = [];
else
  K = pdist2(vertex', controlPts','euclidean');
  K = K.^3;
  
  %% Compute P
  P = [ones(M,1) vertex'];

  %% Compute deformation
  S = sparse(kron(eye(3),[P K]));
  defVertex = S*par;
  deformedVertices = reshape(defVertex,M,3);
end

