function pts = genPtsPlane(a,b,d)
% Generate pts on a plane ax+by+cz = d where c=sqrt(1-a^2-b^2)
% Output : 
% pts - N x 3 matrix of generated pts

%% Find the max of a, b and c
c=sqrt(1-a^2-b^2);
coeff = [a b c];
[maxVal idx] = max(coeff);
A = [0.2, 0.2;
     -0.2, 0.2;
     -0.2, -0.2;
     0.2, -0.2];
r = 0;
if(idx==1)
    c1 = 2;
    c2 = 3;
    r = 1;
elseif(idx==2)
    c1 = 1;
    c2 = 3;
    r = 2;
else
    c1 = 1;
    c2 = 2;
    r = 3;
end
pts(:,c1) = A(:,1);
pts(:,c2) = A(:,2);
pts(:,r) = [ones(4,1) A]*[d;-coeff(c1);-coeff(c2)]/coeff(r);

 

