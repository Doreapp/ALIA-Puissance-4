% Heuristique 5 : min-max statique,
%                 s'il existe joue coup gagnant,
%                 sinon si l'adversaire à un coup gagnant, bloque le,
%                 sinon, en s'appuyant sur un tableau statique qui indique un score pour chaque coup, joue le coup avec le meilleur score

%test maxList
max_l([X],X) :- !, true.
max_l([X|Xs], M):- max_l(Xs, M), M >= X.
max_l([X|Xs], X):- max_l(Xs, M), X >  M.

minmaxStatique(JoueurJouant,Grille,Grille1) :- MMS=[[3,4,5,5,4,3,-1],[4,6,8,8,6,4,-1],[5,8,11,11,8,5,-1],[7,10,13,13,10,7,-1],[5,8,11,11,8,5,-1],[4,6,8,8,6,4,-1],[3,4,5,5,4,3,-1]], heuristiqueMMS(Grille,_,MMS,Grille1,JoueurJouant).

%G la grille du jeu, L la ligne MinMax jouable, MMS le tableau MinMaxStatique
heuristiqueMMS(G,L,MMS,G1,JoueurJouant) :- length(L,T), T < 7,J is T+1, %Trouve l'indice de la colone sur laquelle on travail
                                        joueurOppose(JoueurJouant,JoueurOppose),jouerMove(JoueurJouant, G, J, G2),testMovePourGagner(JoueurOppose, G2,_), %Vérifie si jouer dans cette colonne offre un coup gagnant
                                        nth1(J,G,C), compter(C,N) ,nth1(J,MMS,Cbis),I is 7-N,nth1(I,Cbis,E), %Trouve la case du tableau MMS correspondant
                                        ajouterEnFin(E,L,L1),heuristiqueMMS(G,L1,MMS,G1,JoueurJouant). %Ajoute la valeur au tableau, refais un appel a lui meme
heuristiqueMMS(G,L,MMS,G1,JoueurJouant) :- length(L,T), T < 7,ajouterEnFin(-1,L,L1),heuristiqueMMS(G,L1,MMS,G1,JoueurJouant).
heuristiqueMMS(G,L,_,G1,JoueurJouant) :- max_l(L,X),nth1(I,L,X),jouerMove(JoueurJouant, G, I, G1).
