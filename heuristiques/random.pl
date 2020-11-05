% Heuristique 1 : Aléatoire

% joue l'heuristique random J joueur (1 ou 2), G grille
heuristiqueRandom(Joueur, Grille, Grille1) :- random_between(1,7,Index), nth1(Index,Grille,Colonne), compter(Colonne,Count), joueRandom(Joueur, Grille, Index, Count, Colonne, Grille1).

% joue un coup random
joueRandom(Joueur, Grille, Index, Count, Colonne, Grille1) :- Count\==0,
    ajouter(Colonne, Joueur, Colonne1),
    changeColonne(Grille,Index,Colonne1,[],1,Grille1).
joueRandom(Joueur, Grille, _, 0, _, Grille1) :- heuristiqueRandom(Joueur, Grille, Grille1).
