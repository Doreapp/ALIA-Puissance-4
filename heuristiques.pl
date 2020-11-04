% Chargement des fichiers qui seront utilisés dans ce fichier
:- consult(analyseGagnant).
:- consult(gereTableau).
:- consult(affichage).


% ==================================================
% Heuristique 0 : pas d'IA : joueur humain

jouerJoueur(G,Joueur, N1, N2, Etat,Res) :- ecrit("Joueur joue ",1),ecrit(Joueur,1), ecrit(" entrez un nombre: ",1),
                                read(L), nth1(L,G,C), ajouter(C, Joueur, C1), changeColonne(G,L,C1,[],1,G1),
                                affiche(G1,[],Etat),
                                joueurOppose(Joueur, JoueurOp), heuristique(G1, JoueurOp, [N1|N2],Etat,Res). % gagnant()


% ==================================================
% Heuristique 1 : Aléatoire

% joue l'heuristique random J joueur (1 ou 2), G grille
heuristiqueRandom(Joueur, Grille, Grille1) :- random_between(1,7,Index), nth1(Index,Grille,Colonne), compter(Colonne,Count), joueRandom(Joueur, Grille, Index, Count, Colonne, Grille1).

% joue un coup random
joueRandom(Joueur, Grille, Index, Count, Colonne, Grille1) :- Count\==0,
    ajouter(Colonne, Joueur, Colonne1),
    changeColonne(Grille,Index,Colonne1,[],1,Grille1).
joueRandom(Joueur, Grille, _, 0, _, Grille1) :- heuristiqueRandom(Joueur, Grille, Grille1).


% ==================================================
% Heuristique 2 : s'il existe joue coup gagnant,
%                 sinon joue aléatoirement

% colonne L, si possible.
jouerMove(J, G, L, G1) :- nth1(L,G,C), compter(C,Y), Y\==0, ajouter(C, J, C1), changeColonne(G,L,C1,[],1,G1).

% la colonne C ferrai gagner le joueur J joue un move pour gagner si possible
movePourGagner(Joueur, Grille, Grille1) :- jouerMove(Joueur, Grille, _, Grille1),
    gagner(Joueur, Grille1).


% ==================================================
% Heuristique 3 : s'il existe joue coup gagnant,
%                 sinon si l'adversaire à un coup gagnant, bloque le,
%                 sinon joue aléatoirement

movePourEmpecherGagner(JoueurJouant, JoueurAdverse, Grille, Grille1) :- jouerMove(JoueurAdverse, Grille, Coup, Grille2),
    gagner(JoueurAdverse, Grille2),
    jouerMove(JoueurJouant, Grille, Coup, Grille1).


% ==================================================
% Heuristique 4 : s'il existe joue coup gagnant,
%                 sinon si l'adversaire à un coup gagnant, bloque le,
%                 sinon joue un coup aléatoire qui ne peut pas mener l'adversaire au succès,
%                 sinon joue aléatoirement

% renvoi false si possibilite de gagner et true autrement
testMovePourGagner(Joueur, Grille, G) :- movePourGagner(Joueur, Grille, G), !, fail.
testMovePourGagner(_Joueur, _Grille, _G).

% joue un coup random qui ne mene pas � la victoire de l'adversaire
heuristiqueRandomAvecAnticipation(Joueur, Grille, Grille1) :- joueurOppose(Joueur, JoueurOp), heuristiqueRandom(Joueur, Grille, Grille1), testMovePourGagner(JoueurOp, Grille1, _).


% ==================================================
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



% ==================================================
% Clause heuristique qui execute l'heuristique passé en paramètre

% heuristique(Grille, Joueur, [heuristiqueJoueur1,heuristiqueJoueur2])
% Grille actuel du jeu
% Joueur qui doit jouer

% Si le coup que viens de faire le joueur 1 est gagnant alors j'affiche le gagnant et clos le jeu
heuristique(G,2,_,Etat,1) :- gagner(1,G), afficherGagnant(1,Etat), retour(1,Etat).
% Si le coup que viens de faire le joueur 2 est gagnant alors j'affiche le gagnant et clos le jeu
heuristique(G,1,_,Etat,2) :- gagner(2,G), afficherGagnant(2,Etat), retour(1,Etat).
% Si le jeu n'a plus de coup possible, j'annonce un match nul et clos le jeu.
heuristique(G,_,_,Etat,0) :- finis(G,Etat).

% Si un joueur a une heuristique 0, j'appelle cette heuristique pour ce joueur
heuristique(G,Joueur,[N1|N2],Etat,Res) :- nth1(Joueur,[N1|N2],NIV), NIV = 0, jouerJoueur(G, Joueur, N1, N2,Etat,Res).

% Si un joueur a une heuristique supérieur à 1, j'appelle la stratégie 1
heuristique(G,Joueur,[N1|N2], Etat,Joueur) :- nth1(Joueur,[N1|N2],NIV), NIV > 1, movePourGagner(Joueur, G, G1),
    ecrit(Joueur,Etat), ecrit(" joue pour gagner",Etat), retour(1,Etat),
    affiche(G1,[],Etat),
    afficherGagnant(Joueur,Etat).

% Si un joueur a une heuristique différente de 1, j'appelle la stratégie 2
heuristique(G,Joueur,[N1|N2],Etat,Res) :- nth1(Joueur,[N1|N2],NIV), NIV > 2,
    joueurOppose(Joueur, JoueurOp), movePourEmpecherGagner(Joueur, JoueurOp, G, G1),
    ecrit(Joueur,Etat), ecrit(" joue pour empecher de gagner",Etat), retour(1,Etat),
    affiche(G1,[],Etat),
    heuristique(G1,JoueurOp, [N1|N2],Etat,Res).

% Si un joueur à une heuristique MinMaxStatique, je l'appelle pour ce joueur
heuristique(G,Joueur,[N1|N2],Etat,Res) :- nth1(Joueur,[N1|N2],NIV), NIV = 5, minmaxStatique(Joueur, G, G1),
    ecrit(Joueur,Etat), ecrit(" joue MinMax",Etat), retour(1,Etat),
    affiche(G1,[],Etat),
    joueurOppose(Joueur, JoueurOp),
    heuristique(G1,JoueurOp, [N1|N2],Etat,Res).

% Si un joueur a une heuristique RandomAvecAnticipation, je l'appelle pour ce joueur
heuristique(G,Joueur,[N1|N2],Etat,Res) :- nth1(Joueur,[N1|N2],NIV), NIV = 4, heuristiqueRandomAvecAnticipation(Joueur,G,G1),
    ecrit(Joueur,Etat), ecrit(" joue RandomAvecAnticipation",Etat), retour(1,Etat),
    affiche(G1,[],Etat),
    joueurOppose(Joueur, JoueurOp),
    heuristique(G1,JoueurOp, [N1|N2],Etat,Res).

% Si un joueur a une heuristique Random, je l'appelle pour ce joueur
% Ou si une heuristique supérieur n'a pas réussi, je l'appelle
heuristique(G,Joueur,[N1|N2],Etat,Res) :- nth1(Joueur,[N1|N2],NIV), NIV > 0, heuristiqueRandom(Joueur, G, G1),
    ecrit(Joueur,Etat), ecrit(" joue Random",Etat), retour(1,Etat),
    affiche(G1,[],Etat),
    joueurOppose(Joueur, JoueurOp),
    heuristique(G1,JoueurOp, [N1|N2],Etat,Res).












