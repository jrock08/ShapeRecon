function [ v ] = rejection_sample( v, rejection_size )

d = dist(v);
selected = [1];
for i = 2:size(v, 2)
    if(min(d(i,selected)) > rejection_size)
        selected = [selected, i];
    end
end
v = v(:,selected);


end

