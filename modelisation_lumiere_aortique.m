%Projet de lecture de CT scan et représentation de la lumière aortique
clear variables;
close all;
clc;

%Initialisation
debut = 52;
fin = 80;
nb_scan = fin - debut;
%On ouvre une figure pour accueillir la modelisation de la lumière aortique
figure;
%On crée un vecteur qui va rassembler tous les diamètres de tous les scans
Diametres = zeros(1, nb_scan);
%On crée un vecteur qui va rassembler tous les centres de tous les scans
Centres = zeros(nb_scan, 2); 

%On crée une boucle qui va parcourrir tous les fichiers
for i = debut:fin
    %On lit le scan
    Im_scan = dicomread("CT_scan\CT0000"+i);
    %ON récupère les points du périmetre, du centre et le diametre de la
    %lumière aortique
    [X,Y,Centres(i-debut+1,:),Diametres(i-debut+1)] = segmenter_aorte(Im_scan,i);
    %On cré un vecteur Z qui évolue en fonction de l'indice du scan
    Z = ones(size(Y)) + (i-debut); 
    plot3(X,Y,Z,'c*');
    hold on;
end

%Affichage des centres reliés
plot3(Centres(:, 2), Centres(:, 1),1:nb_scan+1, '-+r');

%Edition de l'affichage du graphique
title("Modélisation 3D de la lumière aortique");
xlabel("X (pixels)");
ylabel("Y (pixels)");
zlabel("Z (coupes)");
grid on;
hold off;

%Affichage de l'évolution du diamètre
figure;
x = 1:nb_scan+1;
plot(x,Diametres,'--+');
title("Evolution du diamètre de la lumière aortique en fonction des coupes");
xlabel("Numéro de coupe");
ylabel("Diametre en px");
grid on;
hold off;

%Calculs de données des diamètres 
Diametre_moyen = mean(Diametres) ;
Diametre_std = std(Diametres);
Diametre_var = (max(Diametres) - min(Diametres)) / Diametre_moyen * 100;
fprintf("Statistiques des diamètres:\n");
fprintf("  - Diamètre moyen: %.2f pixels\n", Diametre_moyen);
fprintf("  - Écart-type: %.2f pixels\n", Diametre_std);
fprintf("  - Diamètre min: %.2f pixels\n", min(Diametres));
fprintf("  - Diamètre max: %.2f pixels\n", max(Diametres));
fprintf("  - Variation du diamètre: %.2f%%\n", Diametre_var);

