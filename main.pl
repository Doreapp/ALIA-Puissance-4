:- consult(heuristiques).

% N1 est le niveau de l'IA du joueur 1, N2 niveau de l'IA pour N2.
% Chaque niveau dIA comprend les fonctionnalités des niveaud d'IA précédente
% Niveau de l'IA:
%   0: pas d'IA, joueur humain
%   1: aléatoire
%   2: s'il existe, joue un coup gagnant
%   3: s'il existe, empèche un coup gagnant adverser
%   4: joue un coup random sans donné un coup gagnant à l'adversaire
%   5: joue un le coup qui offre théoriquement le plus de possiblité d'alignement
% Etat spécifie si l'on veut un affichage du jeu ou non (0 ou 1). C'est
% utile pour faire des stats car l'on ne veut pas afficher tous les
% effectués. Res retour le joueur gagnant
lancerJeu(N1, N2, Etat, Res) :- G=[[0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0],[0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0]],affiche(G,[],Etat), heuristique(G, 1, [N1, N2], Etat,Res).


% stats permet de lancer 50 répétitions de jeu entre deux heuristique N1
% et N2. J1, J2 et Nul sont des compteurs des résultats des joueurs
% Pour lancer une stats : stats(N1,N2,0,0,0,0,0).
stats(N1,N2,50,J1,J2,Nul) :- write(N1), write(" : "), write(J1), nl, write(N2), write(" : "), write(J2), nl, write("Nul : "), write(Nul).
stats(N1,N2,Cpt,J1,J2,Nul) :- lancerJeu(N1,N2,0,X), Cpt1 is Cpt+1, ((X == 1, J1b is J1+1, stats(N1,N2,Cpt1,J1b,J2,Nul));(X == 2, J2b is J2+1, stats(N1,N2,Cpt1,J1,J2b,Nul));(X == 0, Nulb is Nul+1, stats(N1,N2,Cpt1,J1,J2,Nulb))).


