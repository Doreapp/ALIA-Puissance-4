% Chargement des fichiers qui seront utilisés dans ce fichier
:- consult(analyseGagnant).
:- consult(gereTableau).
:- consult(affichage).
:- consult(heuristiques/joueur).
:- consult(heuristiques/random).
:- consult(heuristiques/offensive).
:- consult(heuristiques/defensive).
:- consult(heuristiques/anticipation).
:- consult(heuristiques/minMaxStatique).
:- consult(heuristiques/minMax).


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

% Appel de l'heuristique MinMax
heuristique(G,Joueur,[N1|N2],Etat,Res) :- nth1(Joueur,[N1|N2],NIV), NIV = 6, minMax(G,Joueur,G1),
    ecrit(Joueur,Etat), ecrit(" joue MinMaxNew",Etat), retour(1,Etat),
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












