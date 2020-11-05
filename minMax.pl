% Heuristique minMax
minMax(G,J,G1) :- trouveCoup(G,J,1,C,-2000,1),
    joueCoup(G,J,C,G1).

% Renvoi le coup qui a le meilleur score sur les 8 prochains coups
trouveCoup(_,_,C,C,_,8).
trouveCoup(G,J,CP,CF,SP,Cpt) :-
    Cpt < 8,
    calculCoup(G,J,Cpt,0,S,1),
    Cpt1 is Cpt+1,
    ((S > SP, trouveCoup(G,J,Cpt,CF,S,Cpt1));
    (S =< SP, trouveCoup(G,J,CP,CF,SP,Cpt1))).

% Pour un coup donné, renvoi sont score anticipé sur 8 coups
% Ajoute le score de chaque coup du joueur, et soustrait les scores des
% coups de l'adversaires. Plus les coups sont anticipés plus les scores
% sont faibles (pondération)
calculCoup(_,_,_,S,S,9).
calculCoup(G,J,C,SP,SF,1) :-
    calculScore(G,J,C,S),
    joueCoup(G,J,C,G1),
    ST is SP+S,
    joueurOppose(J,J2),
    calculCoup(G1,J2,C,ST,SF,2).
calculCoup(G,J,CF,SP,SF,Cpt) :-
    Cpt < 9, Cpt > 1,
    coup(G,J,1,C,-2000,S,1),
    joueCoup(G,J,C,G1),
    Cpt1 is Cpt+1,
    ((1 is mod(Cpt,2),ST is SP+S/(Cpt-1));
    (0 is mod(Cpt,2), ST is SP-S/(Cpt-1))),
    joueurOppose(J,J2),
    calculCoup(G1,J2,CF,ST,SF,Cpt1).

% Pour une grille, renvoi le coup avec le meilleur score et son score
% associé
coup(_,_,C,C,S,S,8).
coup(G,J,CP,CF,SP,SF,Cpt) :-
    calculScore(G,J,Cpt,S),
    Cpt1 is Cpt+1,
    ((S > SP, coup(G,J,Cpt,CF,S,SF,Cpt1));
    (S =< SP, coup(G,J,CP,CF,SP,SF,Cpt1))).

% Calcul le score d'un coup
calculScore(_,_,0,-2000).
calculScore(Grille,Joueur,IndexColonne,Score) :-
    nth1(IndexColonne,Grille,Colonne),
    compter(Colonne,N),
    ((N = 0, calculScore(Grille,Joueur,0,Score));
    (IndexLigne is 7-N,
    scoreLigne(Grille,Joueur,IndexColonne,IndexLigne,R1),
    scoreColonne(Grille,Joueur,IndexColonne,IndexLigne,R2),
    scoreDiag1(Grille,Joueur,IndexColonne,IndexLigne,R3),
    scoreDiag2(Grille,Joueur,IndexColonne,IndexLigne,R4),
    Score is R1+R2+R3+R4)).

% Joue le Coup pour le Joueur sur la Grille et renvoi la nouvelle
% Grille1
joueCoup(Grille,Joueur,Coup,Grille1) :-
    nth1(Coup,Grille,Colonne),
    ajouterEnFin(Joueur,Colonne,Colonne1),
    changeColonne(Grille,Coup,Colonne1,[],1,Grille1).

% Renvoi le nombre de symbole aligné horizontalement du joueur J si il
% joue la case (X,Y)
scoreLigne(Grille,J,X,Y,Retour) :-
    regardeGauche(Grille,J,X,Y,0,R1),
    regardeDroite(Grille,J,X,Y,0,R2),
    R is R1+R2+1,
    getScore(R,Retour).

% Renvoi le nombre de symbole du joueur J sur la gauche de la ligne de
% la case (X,Y)
regardeGauche(_,_,1,_,Cpt,Cpt).
regardeGauche(Grille,J,X,Y,Cpt,Retour) :- X1 is X-1, getCase(Grille,X1,Y,J), Cpt1 is Cpt+1, regardeGauche(Grille,J,X1,Y,Cpt1,Retour).
regardeGauche(Grille,J,X,Y,Cpt,Retour) :- X1 is X-1, getCase(Grille,X1,Y,R), R\==J, regardeGauche(Grille,J,1,Y,Cpt,Retour).

% Renvoi le nombre de symbole du joueur J sur la droite de la ligne de
% la case (X,Y)
regardeDroite(_,_,7,_,Cpt,Cpt).
regardeDroite(Grille,J,X,Y,Cpt,Retour) :- X1 is X+1, getCase(Grille,X1,Y,J), Cpt1 is Cpt+1, regardeDroite(Grille,J,X1,Y,Cpt1,Retour).
regardeDroite(Grille,J,X,Y,Cpt,Retour) :- X1 is X+1, getCase(Grille,X1,Y,R), R\==J, regardeDroite(Grille,J,7,Y,Cpt,Retour).

% Renvoi le nombre de symbole aligné verticalement du joueur J si il
% joue la case (X,Y)
scoreColonne(Grille,J,X,Y,Retour) :- regardeBas(Grille,J,X,Y,0,R1), R is R1+1, getScore(R,Retour).

% Renvoi le nombre de symbole du joueur J sur en dessous de la case
% (X,Y)
regardeBas(_,_,_,1,Cpt,Cpt).
regardeBas(Grille,J,X,Y,Cpt,Retour) :- Y1 is Y-1, getCase(Grille,X,Y1,J), Cpt1 is Cpt+1, regardeBas(Grille,J,X,Y1,Cpt1,Retour).
regardeBas(Grille,J,X,Y,Cpt,Retour) :- Y1 is Y-1, getCase(Grille,X,Y1,R), R\==J, regardeBas(Grille,J,X,1,Cpt,Retour).

% Renvoi le nombre de symbole du joueur J sur la gauche de la diagonale
% 1 de la case (X,Y)
regardeDiag1Gauche(_,_,1,_,Cpt,Cpt).
regardeDiag1Gauche(_,_,X,6,Cpt,Cpt) :- X\==1.
regardeDiag1Gauche(Grille,J,X,Y,Cpt,Retour) :- X1 is X-1, Y1 is Y+1, getCase(Grille,X1,Y1,J), Cpt1 is Cpt+1, regardeDiag1Gauche(Grille,J,X1,Y1,Cpt1,Retour).
regardeDiag1Gauche(G,J,X,Y,Cpt,R) :- X1 is X-1, Y1 is Y+1, getCase(G,X1,Y1,Res), Res\==J, regardeDiag1Gauche(G,J,1,7,Cpt,R).

% Renvoi le nombre de symbole du joueur J sur la droite de la diagonale
% 1 de la case (X,Y)
regardeDiag1Droite(_,_,7,_,Cpt,Cpt).
regardeDiag1Droite(_,_,X,1,Cpt,Cpt) :- X\==7.
regardeDiag1Droite(Grille,J,X,Y,Cpt,Retour) :- X1 is X+1, Y1 is Y-1, getCase(Grille,X1,Y1,J), Cpt1 is Cpt+1, regardeDiag1Droite(Grille,J,X1,Y1,Cpt1,Retour).
regardeDiag1Droite(G,J,X,Y,Cpt,R) :- X1 is X+1, Y1 is Y-1, getCase(G,X1,Y1,Res), Res\==J, regardeDiag1Droite(G,J,7,1,Cpt,R).

% Renvoi le nombre de symbole du joueur J sur la diagonale 1 de la case
% (X,Y)
scoreDiag1(G,J,X,Y,R) :- regardeDiag1Gauche(G,J,X,Y,0,R1), regardeDiag1Droite(G,J,X,Y,0,R2), R3 is R1+R2+1, getScore(R3,R).

% Renvoi le nombre de symbole du joueur J sur la gauche de la diagonale
% 2 de la case (X,Y)
regardeDiag2Gauche(_,_,1,_,Cpt,Cpt).
regardeDiag2Gauche(_,_,X,1,Cpt,Cpt) :- X\==1.
regardeDiag2Gauche(Grille,J,X,Y,Cpt,Retour) :- X1 is X-1, Y1 is Y-1, getCase(Grille,X1,Y1,J), Cpt1 is Cpt+1, regardeDiag2Gauche(Grille,J,X1,Y1,Cpt1,Retour).
regardeDiag2Gauche(G,J,X,Y,Cpt,R) :- X1 is X-1, Y1 is Y-1, getCase(G,X1,Y1,Res), Res\==J, regardeDiag2Gauche(G,J,1,1,Cpt,R).

% Renvoi le nombre de symbole du joueur J sur la droite de la diagonale
% 2 de la case (X,Y)
regardeDiag2Droite(_,_,7,_,Cpt,Cpt).
regardeDiag2Droite(_,_,X,6,Cpt,Cpt) :- X\==7.
regardeDiag2Droite(Grille,J,X,Y,Cpt,Retour) :- X1 is X+1, Y1 is Y+1, getCase(Grille,X1,Y1,J), Cpt1 is Cpt+1, regardeDiag2Droite(Grille,J,X1,Y1,Cpt1,Retour).
regardeDiag2Droite(G,J,X,Y,Cpt,R) :- X1 is X+1, Y1 is Y+1, getCase(G,X1,Y1,Res), Res\==J, regardeDiag2Droite(G,J,7,7,Cpt,R).

% Renvoi le nombre de symbole du joueur J sur la diagonale 2 de la case
% (X,Y)
scoreDiag2(G,J,X,Y,R) :- regardeDiag2Gauche(G,J,X,Y,0,R1), regardeDiag2Droite(G,J,X,Y,0,R2), R3 is R1+R2+1, getScore(R3,R).

% Récupère la case (Colonne,Ligne) de la Grille
getCase(Grille,Colonne,Ligne,Retour) :- nth1(Colonne,Grille,C), nth1(Ligne,C,Retour).

% Création d'un score en fonction du nombre de symbole alignés
getScore(1,5).
getScore(2,20).
getScore(3,100).
getScore(X,2000) :- X > 3.
