% Ajoute en fin de colonne
ajouterEnFin(X,[0|T],[X|T]).
ajouterEnFin(X,[],[X]).
ajouterEnFin(X,[H|L1],[H|L2]):- H\==0, ajouterEnFin(X,L1,L2).

% Essaie d'ajouter l'élément X Ã  la colonne C
ajouter(C,_,C) :- compter(C,0).
ajouter(C,X,A) :- compter(C,N), N \== 0,ajouterEnFin(X,C,A).

% Q renvoi la liste passé en premier paramatre mais la colonne X est changée par la colonne C
changeColonne([],_,_,G1,8,G1).
changeColonne([H|T], X, C, G1, N,Q) :- N \== X, append(G1,[H],G2), N1 is N+1, changeColonne(T,X,C,G2,N1,Q).
changeColonne([_|T], X, C, G1, X,Q) :- append(G1,[C],G2), N1 is X+1, changeColonne(T,X,C,G2,N1,Q).