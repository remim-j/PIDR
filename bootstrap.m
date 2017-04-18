function [M] = bootstrap(S)
%Génère M à partir de S
n = length(S)
M = size(S);
for i=1:n
    r = 1 + (n-1) * rand(1);
    M(i) = S(r);
end
M;
