:- consult(heuristiques).

% N1 est le niveau de l'IA du joueur 1, N2 niveau de l'IA pour N2.
% Chaque niveau dIA comprend les fonctionnalit�s des niveaud d'IA pr�c�dente
% Niveau de l'IA:
%   0: pas d'IA, joueur humain
%   1: al�atoire
%   2: s'il existe, joue un coup gagnant
%   3: s'il existe, emp�che un coup gagnant adverser
%   4: joue un coup random sans donn� un coup gagnant � l'adversaire
%   5: joue un le coup qui offre th�oriquement le plus de possiblit� d'alignement

lancerJeu(N1, N2) :- G=[[0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0]], affiche(G,[]), heuristique(G, 1, [N1, N2]).
