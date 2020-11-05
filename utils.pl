% ** Retourne vrai si la liste H au dÃ©but de L **
prefixe(H,L):-append(H,_,L).

% ** Retourne si ML est une sous-liste de L **
sousliste(ML,L):- prefixe(ML,L). % si ML au dÃ©but de L
sousliste(ML,[_|T]):- sousliste(ML,T).

% Compte le nombre N de de zero dans L avec count(L,N)
compter([],0).
compter([0|T],N) :- compter(T,N1), N is N1 + 1.
compter([X|T],N) :- X \== 0, compter(T,N).

%renvoi le joueur oppose
joueurOppose(1,2).
joueurOppose(2,1).
