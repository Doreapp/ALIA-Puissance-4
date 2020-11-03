%Afficher gagnant
afficherGagnant(J):- write("Le joueur "),write(J),write(" a gagne"),nl.


% Affiche La grille L
affiche([],L) :- afficheColonne(L,0,0),nl,nl,nl,nl,nl.
affiche([H|T],L) :- reverse(H,R), append(L,[R],L2), affiche(T,L2).

afficheColonne(_,_,6).
afficheColonne(L,7,B) :- nl, B1 is B+1, afficheColonne(L,0,B1).
afficheColonne([[H1|T1]|T],A,B) :- H1\==[],H1 == 1, write("X"), append(T,[T1],L), A1 is A+1, afficheColonne(L,A1,B).
afficheColonne([[H1|T1]|T],A,B) :- H1\==[],H1 == 2, write("O"), append(T,[T1],L), A1 is A+1, afficheColonne(L,A1,B).
afficheColonne([[H1|T1]|T],A,B) :- H1\==[],H1 == 0, write("."), append(T,[T1],L), A1 is A+1, afficheColonne(L,A1,B).