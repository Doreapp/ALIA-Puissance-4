%Affiche un N retour à la ligne en fct du paramètre
retour(_,0).
retour(0,1).
retour(N,1) :- N > 0, nl, N1 is N-1, retour(N1,1).

%Affiche le message sur le 2ème paramètre est 1 sinon n'affiche rien
ecrit(_,0).
ecrit(Message,1) :- write(Message).

%Afficher gagnant
afficherGagnant(_,0).
afficherGagnant(J,1):- write("Le joueur "),write(J),write(" a gagne"),nl.


% Affiche La grille L
affiche(_,_,0).
affiche([],L,1) :- afficheColonne(L,0,0),retour(5,1).
affiche([H|T],L,1) :- reverse(H,R), append(L,[R],L2), affiche(T,L2,1).

afficheColonne(_,_,6).
afficheColonne(L,7,B) :- nl, B1 is B+1, afficheColonne(L,0,B1).
afficheColonne([[H1|T1]|T],A,B) :- H1\==[],H1 == 1, A < 7, write("X"), append(T,[T1],L), A1 is A+1, afficheColonne(L,A1,B).
afficheColonne([[H1|T1]|T],A,B) :- H1\==[],H1 == 2, A < 7, write("O"), append(T,[T1],L), A1 is A+1, afficheColonne(L,A1,B).
afficheColonne([[H1|T1]|T],A,B) :- H1\==[],H1 == 0, A < 7, write("."), append(T,[T1],L), A1 is A+1, afficheColonne(L,A1,B).
