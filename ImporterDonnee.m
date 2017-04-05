% Import des fichiers
Rp = csvread('Xpers_counting_game_plos_one.csv');
Mo = csvread('Xmean_counting_game_plos_one.csv');
[x, y] = size(Rp);

%Initialisation de M
M = [0 0 0 0];
%Colonne1 : yi(1); Colonne2 : yi(2); Colonne3 : yi(3); Colonne4 : moyenne 2nd tour
for i=1:(x/6)
    for j=1:30
        M = [M; Rp((6*(i-1)+1):(6*i), j) Rp((6*(i-1)+1):(6*i), 30+j) Rp((6*(i-1)+1):(6*i), 60+j) Mo((6*(i-1)+1):(6*i), 30+j)];
    end
end
M(1,:)=[];
