% Import des fichiers
Rp = csvread('data_pidr_2017/Xpers_gauging_game_plos_one.csv');
Mo = csvread('data_pidr_2017/Xmean_gauging_game_plos_one.csv');
max = 100;
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

%On retire les valeurs nan des listes pour pouvoir faire les plots
for i=length(y):-1:1
    if isnan(ypredit(i)) | isnan(yreel(i))
        yreel(i) = [];
        ypredit(i) = [];
    end
end

figure(1)
plot(ypredit, ypredit, ypredit, yreel, '.')
xlabel('y predit');
ylabel('y reel');
figure(2)
plot(yreel, (yreel-ypredit), '.')
xlabel('y reel');
ylabel('erreur');

%% erreur moyenne/écart type

erreur = yreel-ypredit;
merreur = zeros(20,1);
mcpt = zeros(20,1);
pas = max / 20;
for i=1:length(yreel)
    p = floor(yreel(i)/pas)+1;
    merreur(p) = merreur(p) + erreur(i);
    mcpt(p) = mcpt(p) + 1;
end

for i=1:length(merreur)
    if (mcpt(i) ~= 0)
        merreur(i) = merreur(i)/mcpt(i);
    end
end

mecart = zeros(20,1);
for i=1:length(yreel)
    p = floor(yreel(i)/pas)+1;
    mecart(p) = mecart(p) + (erreur(i)-merreur(p))^2;
end
mecart
for i=1:length(mecart)
    if (mcpt(i) ~= 0)
        mecart(i) = mecart(i)/mcpt(i);
    end
    mecart(i) = sqrt(mecart(i))
end

figure('Name','Moyenne des erreurs sur une plage de 25')
plot([1:pas:max], merreur,'.',[1:pas:max],mecart,'.', 'MarkerSize', 20)
legend('moyenne erreur','ecart type erreur');

%% Bootstrap
disp('Bootstrap');

bboot = zeros(1, 5000);
for i=1:5000
    [boot] = bootstrap(M);
    yb = boot(:,3);
    Xb = [ ones(size(y)) boot(:, [1 2 4])];
    [bb,bintb,rb,rintb,statsb] = regress(yb,Xb);
    bboot(i) = bb(2);
end

bboot;
%% Exploitation bootstrap
    
histogram(bboot)
[val, idx] = sort(bboot);
binf = val(floor(length(bboot)*0.025));
bsup = val(floor(length(bboot)*0.975));

disp('Interval de confience à 95%')
binf
bsup

%Calcul de la p valeur
pval = sum(abs(bboot-mean(bboot))>=mean(bboot))/length(bboot)







