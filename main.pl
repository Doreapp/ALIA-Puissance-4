% ** Retourne la longueur de la liste **
longueur([],0).
longueur([_|T],L):- longueur(T,L1),L is L1+1.

% ** Retourne vrai si la liste H au dÃ©but de L **
prefixe(H,L):-append(H,_,L).

% ** Retourne si ML est une sous-liste de L **
sousliste(ML,L):-prefixe(ML,L). % si ML au dÃ©but de L
sousliste(ML,[_|T]):-sousliste(ML,T).

% * Retourne le Nième élement de la liste *
element(N, L, []):- longueur(L, N1), N1 < N.
element(N, L, X):- nth1(N, L, X).

% * Retourne si le joueur J a gagné sur une colonne *
gagnerColonne(J, [H|_]) :- sousliste([J,J,J,J], H).
gagnerColonne(J, [_|T]) :- T \== [], gagnerColonne(J, T).

% ** Retourne si le joueur J à gagner sur la ligne Y
gagnerLigne(J, Y, G):- maplist(element(Y),G,L), sousliste([J,J,J,J], L).

gagnerLignes(J, G):- gagnerLigne(J, 1, G).
gagnerLignes(J, G):- gagnerLigne(J, 2, G).
gagnerLignes(J, G):- gagnerLigne(J, 3, G).
gagnerLignes(J, G):- gagnerLigne(J, 4, G).
gagnerLignes(J, G):- gagnerLigne(J, 5, G).
gagnerLignes(J, G):- gagnerLigne(J, 6, G).

% Regarder si le joueur J a gagnÃ©
% 1. Les colonnes
gagner(J, G):- gagnerColonne(J, G).

% 2. Les lignes
gagner(J,G):- gagnerLignes(J,G).

% 3.1. Recherche les diagonales (type \) dans G
gagner(J,G):- sousliste([C1,C2,C3,C4], G), % RÃ©cup 4 colonnes
		   element(I1,J,C1), % qui contiennent J
                   element(I2,J,C2),
		   element(I3,J,C3),
		   element(I4,J,C4),
                   I2 is I1+1, I3 is I2+1, I4 is I3+1. % Et chacun sont sur une mÃªme diagonale \

% 3.2. Recherche les diagonales (type /) dans G
gagner(J,G):- sousliste([C1,C2,C3,C4], G), % RÃ©cup 4 colonnes
		   element(I1,J,C1), % qui contiennent J
                   element(I2,J,C2),
		   element(I3,J,C3),
		   element(I4,J,C4),
                   I2 is I1-1, I3 is I2-1, I4 is I3-1. % Et chacun sont sur une mÃªme diagonale /

% Affiche La grille L
affiche([],L) :- afficheColonne(L,0,0).
affiche([H|T],L) :- reverse(H,R), append(L,[R],L2), affiche(T,L2).

afficheColonne(_,_,6).
afficheColonne(L,7,B) :- nl, B1 is B+1, afficheColonne(L,0,B1).
afficheColonne([[H1|T1]|T],A,B) :- H1\==[], write(H1), append(T,[T1],L), A1 is A+1, afficheColonne(L,A1,B).

% Compte le nombre N de de zéro dans L avec count(L,N)
compter([],0).
compter([0|T],N) :- compter(T,N1), N is N1 + 1.
compter([X|T],N) :- X \== 0, compter(T,N).

% Ajoute en fin de colonne
ajouterEnFin(X,[0|T],[X|T]).
ajouterEnFin(X,[],[X]).
ajouterEnFin(X,[H|L1],[H|L2]):- ajouterEnFin(X,L1,L2).

% Essaie d'ajouter l'élément X Ã  la colonne C
ajouter(C,_,C) :- compter(C,0).
ajouter(C,X,A) :- compter(C,N), N \== 0,ajouterEnFin(X,C,A).

% Q renvoi la liste passé en premier paramÃ¨tre mais la colonne X est changée par la colonne C
changeColonne([],_,_,G1,8,G1).
changeColonne([H|T], X, C, G1, N,Q) :- N \== X, append(G1,[H],G2), N1 is N+1, changeColonne(T,X,C,G2,N1,Q).
changeColonne([_|T], X, C, G1, X,Q) :- append(G1,[C],G2), N1 is X+1, changeColonne(T,X,C,G2,N1,Q).

%changeColonne([[1,0,0,0,0,0],[1,2,0,0,0,0],[2,1,0,0,0,0],[1,2,1,0,0,0],[1,1,2,1,0,0],[1,1,1,1,0,0],[1,2,0,0,0,0]],4,[0,0,0,0,0,0],[],0,G).

lancerJeu(_) :- G=[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]], affiche(G,[]), heuristique1(G). % ajouter l'appel à la premiÃ¨re heuristique

heuristique1(G) :- gagner(1,G).
heuristique1(G) :- gagner(2,G).
heuristique1(G) :- random2(G). %jouerJoueur1(G).
heuristique2(G) :- gagner(1,G).
heuristique2(G) :- gagner(2,G).
heuristique2(G) :- random(G). %jouerJoueur2(G)


jouerJoueur1(G) :- write("Joue, J1 :"), read(L), nth1(L,G,C), ajouter(C, 1, C1), changeColonne(G,L,C1,[],1,G1), affiche(G1,[]), heuristique2(G1). % gagnant(), jouerJoueur2().

jouerJoueur2(G) :- write("Joue, J2 :"), read(L), nth1(L,G,C), ajouter(C, 2, C1), changeColonne(G,L,C1,[],1,G1), affiche(G1,[]), heuristique1(G1).

random(G) :- random_between(1,7,X), nth1(X,G,C), compter(C,Y), Y\==0, write("Random joue "), write(X), nl, ajouter(C, 2, C1), changeColonne(G,X,C1,[],1,G1), affiche(G1,[]), heuristique1(G1).

random2(G) :- random_between(1,7,X), nth1(X,G,C), compter(C,Y), Y\==0, write("Random joue "), write(X), nl, ajouter(C, 1, C1), changeColonne(G,X,C1,[],1,G1), affiche(G1,[]), heuristique2(G1).

% Cr�e la grille G1 � partir de G dans laquelle le joueur J � jou� la
% colonne L, si possible.
jouerMove(J, G, L, G1) :- nth1(L,G,C), compter(C,Y), Y\==0, ajouter(C, J, C1), changeColonne(G,L,C1,[],1,G1).

% la colonne C ferrai gagner le joueur J joue un move pour gagner si possible
movePourGagner(J, G, C) :- jouerMove(J, G, C, G1), gagner(J, G1).
