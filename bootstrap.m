function [M] = bootstrap(S)
%G�n�re M � partir de S
n = length(S)
M = size(S);
for i=1:n
    r = 1 + (n-1) * rand(1);
    M(i) = S(r);
end
M;
