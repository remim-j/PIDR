% Import des fichiers
Rp = csvread('Xpers_counting_game_plos_one.csv');
Mo = csvread('Xmean_counting_game_plos_one.csv');
[x, y] = size(Rp);

%Initialisation de M
M = zeros(x*30,4);
%Colonne1 : yi(1); Colonne2 : yi(2); Colonne3 : yi(3); Colonne4 : moyenne 2nd tour
p=1;
for i=1:(x/6)
    for j=1:30
        M(p:(p+5), :) = [Rp((6*(i-1)+1):(6*i), [j 30+j 60+j]) Mo((6*(i-1)+1):(6*i), 30+j)];
        p=p+6;
    end
end

y = M(:,3);
X = [ ones(size(y)) M(:, [1 2 4])];
alpha = 0.05;

[b,bint,r,rint,stats] = regress(y,X);

disp('Odonnée_à_origine, yi(1), yi(2), myi(2)');
b'
disp('r_stat, f_stat, p valeur de f_stat, estimation erreur variance');
stats(4)
%stats

%% Graph

ypredit = b(1)*X(:,1) + b(2)*X(:,2) + b(3)*X(:,3) + b(4)*X(:,4);
yreel = y;

for i=length(y):-1:1
    if isnan(ypredit(i)) | isnan(yreel)
        yreel(i) = [];
        ypredit(i) = [];
    end
end

figure(1)
plot(ypredit, ypredit, ypredit, yreel, '.')
figure(2)
plot(yreel, (yreel-ypredit), '.')


%figure('graph')
%plot(ypredit, ypredit)