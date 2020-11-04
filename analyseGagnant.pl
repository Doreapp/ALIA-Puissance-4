:- consult(utils).

% * Retourne si le joueur J a gagne sur une colonne *
gagnerColonne(J, [H|_]) :- sousliste([J,J,J,J], H).
gagnerColonne(J, [_|T]) :- T \== [], gagnerColonne(J, T).

% ** Retourne si le joueur J à gagner sur la ligne Y
gagnerLigne(J, Y, G):- maplist(nth1(Y),G,L), sousliste([J,J,J,J], L).

gagnerLignes(J, G):- gagnerLigne(J, Y, G), Y>0, Y<7.

% Regarder si le joueur J a gagnÃ©
% 1. Les colonnes
gagner(J, G):- gagnerColonne(J, G).

% 2. Les lignes
gagner(J,G):- gagnerLignes(J,G).

% 3.1. Recherche les diagonales (type \) dans G
gagner(J,G):- sousliste([C1,C2,C3,C4], G), % Recup 4 colonnes
		   element(I1,C1,J), % qui contiennent J
                   I2 is I1+1,
                   element(I2,C2,J),
                   I3 is I2+1,
		   element(I3,C3,J),

                   I4 is I3+1,
		   element(I4,C4,J).
                   % Et chacun sont sur une meme diagonale \

% 3.2. Recherche les diagonales (type /) dans G
gagner(J,G):- sousliste([C1,C2,C3,C4], G), % Recup 4 colonnes
		   element(I1,C1,J), % qui contiennent J
                   I2 is I1-1,
                   element(I2,C2,J),
                   I3 is I2-1,
		   element(I3,C3,J),
                   I4 is I3-1,
		   element(I4,C4,J).
                   % Et chacun sont sur une meme diagonale /


% Check si la grille est complete
finis([]) :- write("Fini : match nul").
finis([H|T]) :- compter(H,Y), Y==0, finis(T).
