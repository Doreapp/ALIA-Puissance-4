
minMax(G,J,G1) :- coup(G,J,1,C,-2000,1),
    joueCoup(G,J,C,G1).

coup(_,_,C,C,_,8).
coup(G,J,CP,CF,SP,Cpt) :-
    calculCoup(G,J,Cpt,S),
    Cpt1 is Cpt+1,
    ((S > SP, coup(G,J,Cpt,CF,S,Cpt1));
    (S =< SP, coup(G,J,CP,CF,SP,Cpt1))).

calculCoup(G,J,C,S) :-
    calculScore(G,J,C,R),
    joueCoup(G,J,C,G1),
    joueurOppose(J,J2),
    trouveCoup(G1,J2,1,1,1,0,0,R2),
    S is R+R2.

trouveCoup(_,_,_,_,4,_,ScoreMax,ScoreMax).
trouveCoup(Grille,Joueur,Coup,8,Cpt2,ScoreCoup,ScoreMax,S) :-
    1 is mod(Cpt2,2),
    joueCoup(Grille,Joueur,Coup,Grille1),
    joueurOppose(Joueur,JoueurOpp),
    Cpt is Cpt2+1,
    Score is ScoreMax-ScoreCoup/Cpt2,
    trouveCoup(Grille1,JoueurOpp,1,1,Cpt,0,Score,S).
trouveCoup(Grille,Joueur,Coup,8,Cpt2,ScoreCoup,ScoreMax,S) :-
    0 is mod(Cpt2,2),
    joueCoup(Grille,Joueur,Coup,Grille1),
    joueurOppose(Joueur,JoueurOpp),
    Cpt is Cpt2+1,
    Score is ScoreMax+ScoreCoup/Cpt2,
    trouveCoup(Grille1,JoueurOpp,1,1,Cpt,0,Score,S).
trouveCoup(Grille,Joueur,Coup,Cpt1,Cpt2,Score,ScoreMax,S) :-
    Cpt1 < 8,
    calculScore(Grille,Joueur,Cpt1,Result),
    Cpt is Cpt1+1,
    ((Result > Score, trouveCoup(Grille,Joueur,Cpt1,Cpt,Cpt2,Result,ScoreMax,S));
    (Result =< Score, trouveCoup(Grille,Joueur,Coup,Cpt,Cpt2,Score,ScoreMax,S))).

joueCoup(Grille,Joueur,Coup,Grille1) :-
    nth1(Coup,Grille,Colonne),
    ajouterEnFin(Joueur,Colonne,Colonne1),
    changeColonne(Grille,Coup,Colonne1,[],1,Grille1).

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

scoreLigne(Grille,J,X,Y,Retour) :-
    regardeGauche(Grille,J,X,Y,0,R1),
    regardeDroite(Grille,J,X,Y,0,R2),
    R is R1+R2+1,
    getScore(R,Retour).

regardeGauche(_,_,1,_,Cpt,Cpt).
regardeGauche(Grille,J,X,Y,Cpt,Retour) :- X1 is X-1, getCase(Grille,X1,Y,J), Cpt1 is Cpt+1, regardeGauche(Grille,J,X1,Y,Cpt1,Retour).
regardeGauche(Grille,J,X,Y,Cpt,Retour) :- X1 is X-1, getCase(Grille,X1,Y,R), R\==J, regardeGauche(Grille,J,1,Y,Cpt,Retour).


regardeDroite(_,_,7,_,Cpt,Cpt).
regardeDroite(Grille,J,X,Y,Cpt,Retour) :- X1 is X+1, getCase(Grille,X1,Y,J), Cpt1 is Cpt+1, regardeDroite(Grille,J,X1,Y,Cpt1,Retour).
regardeDroite(Grille,J,X,Y,Cpt,Retour) :- X1 is X+1, getCase(Grille,X1,Y,R), R\==J, regardeDroite(Grille,J,7,Y,Cpt,Retour).

scoreColonne(Grille,J,X,Y,Retour) :- regardeBas(Grille,J,X,Y,0,R1), R is R1+1, getScore(R,Retour).

regardeBas(_,_,_,1,Cpt,Cpt).
regardeBas(Grille,J,X,Y,Cpt,Retour) :- Y1 is Y-1, getCase(Grille,X,Y1,J), Cpt1 is Cpt+1, regardeBas(Grille,J,X,Y1,Cpt1,Retour).
regardeBas(Grille,J,X,Y,Cpt,Retour) :- Y1 is Y-1, getCase(Grille,X,Y1,R), R\==J, regardeBas(Grille,J,X,1,Cpt,Retour).


regardeDiag1Gauche(_,_,1,_,Cpt,Cpt).
regardeDiag1Gauche(_,_,X,6,Cpt,Cpt) :- X\==1.
regardeDiag1Gauche(Grille,J,X,Y,Cpt,Retour) :- X1 is X-1, Y1 is Y+1, getCase(Grille,X1,Y1,J), Cpt1 is Cpt+1, regardeDiag1Gauche(Grille,J,X1,Y1,Cpt1,Retour).
regardeDiag1Gauche(G,J,X,Y,Cpt,R) :- X1 is X-1, Y1 is Y+1, getCase(G,X1,Y1,Res), Res\==J, regardeDiag1Gauche(G,J,1,7,Cpt,R).

regardeDiag1Droite(_,_,7,_,Cpt,Cpt).
regardeDiag1Droite(_,_,X,1,Cpt,Cpt) :- X\==7.
regardeDiag1Droite(Grille,J,X,Y,Cpt,Retour) :- X1 is X+1, Y1 is Y-1, getCase(Grille,X1,Y1,J), Cpt1 is Cpt+1, regardeDiag1Droite(Grille,J,X1,Y1,Cpt1,Retour).
regardeDiag1Droite(G,J,X,Y,Cpt,R) :- X1 is X+1, Y1 is Y-1, getCase(G,X1,Y1,Res), Res\==J, regardeDiag1Droite(G,J,7,1,Cpt,R).

scoreDiag1(G,J,X,Y,R) :- regardeDiag1Gauche(G,J,X,Y,0,R1), regardeDiag1Droite(G,J,X,Y,0,R2), R3 is R1+R2+1, getScore(R3,R).

regardeDiag2Gauche(_,_,1,_,Cpt,Cpt).
regardeDiag2Gauche(_,_,X,1,Cpt,Cpt) :- X\==1.
regardeDiag2Gauche(Grille,J,X,Y,Cpt,Retour) :- X1 is X-1, Y1 is Y-1, getCase(Grille,X1,Y1,J), Cpt1 is Cpt+1, regardeDiag2Gauche(Grille,J,X1,Y1,Cpt1,Retour).
regardeDiag2Gauche(G,J,X,Y,Cpt,R) :- X1 is X-1, Y1 is Y-1, getCase(G,X1,Y1,Res), Res\==J, regardeDiag2Gauche(G,J,1,1,Cpt,R).

regardeDiag2Droite(_,_,7,_,Cpt,Cpt).
regardeDiag2Droite(_,_,X,6,Cpt,Cpt) :- X\==7.
regardeDiag2Droite(Grille,J,X,Y,Cpt,Retour) :- X1 is X+1, Y1 is Y+1, getCase(Grille,X1,Y1,J), Cpt1 is Cpt+1, regardeDiag2Droite(Grille,J,X1,Y1,Cpt1,Retour).
regardeDiag2Droite(G,J,X,Y,Cpt,R) :- X1 is X+1, Y1 is Y+1, getCase(G,X1,Y1,Res), Res\==J, regardeDiag2Droite(G,J,7,7,Cpt,R).

scoreDiag2(G,J,X,Y,R) :- regardeDiag2Gauche(G,J,X,Y,0,R1), regardeDiag2Droite(G,J,X,Y,0,R2), R3 is R1+R2+1, getScore(R3,R).


getCase(Grille,Colonne,Ligne,Retour) :- nth1(Colonne,Grille,C), nth1(Ligne,C,Retour).

getScore(1,5).
getScore(2,20).
getScore(3,100).
getScore(X,1000) :- X > 3.
