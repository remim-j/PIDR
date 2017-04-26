function [R] = bootstrap(S)
%G�n�re M � partir de S
n = length(S);
R = zeros(size(S));
for i=1:1:n
    r = floor(1 + (n) * rand(1));
    R(i,:) = S(r,:);
end
R;
