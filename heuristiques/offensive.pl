% Heuristique 2 : s'il existe joue coup gagnant,
%                 sinon joue aléatoirement

% colonne L, si possible.
jouerMove(J, G, L, G1) :- nth1(L,G,C), compter(C,Y), Y\==0, ajouter(C, J, C1), changeColonne(G,L,C1,[],1,G1).

% la colonne C ferrai gagner le joueur J joue un move pour gagner si possible
movePourGagner(Joueur, Grille, Grille1) :- jouerMove(Joueur, Grille, _, Grille1),
    gagner(Joueur, Grille1).
