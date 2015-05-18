function uVal = U(vec1, vec2)
% Computes the radial basis function value 
% Input -
% vec1 - 3 x 1 vector 
% vec2 - 3 x 1 vector
% Output - 
% uVal - |vec1-vec2| x ln|vec1-vec2|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = vec1 - vec2;
l2 = norm(p,2);
uVal = l2^3;
% uVal = (l2^2)*log((l2+0.0001));
% if(l2<0.5)
%     uVal = (l2^2)*log(l2+0.0001);
% else
% %     uVal = 0.25*log(0.25);
%     uVal = 0;
% end