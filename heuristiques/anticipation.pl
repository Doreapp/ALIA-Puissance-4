% Heuristique 4 : s'il existe joue coup gagnant,
%                 sinon si l'adversaire à un coup gagnant, bloque le,
%                 sinon joue un coup aléatoire qui ne peut pas mener l'adversaire au succès,
%                 sinon joue aléatoirement

% renvoi false si possibilite de gagner et true autrement
testMovePourGagner(Joueur, Grille, G) :- movePourGagner(Joueur, Grille, G), !, fail.
testMovePourGagner(_Joueur, _Grille, _G).

% joue un coup random qui ne mene pas � la victoire de l'adversaire
heuristiqueRandomAvecAnticipation(Joueur, Grille, Grille1) :- joueurOppose(Joueur, JoueurOp), heuristiqueRandom(Joueur, Grille, Grille1), testMovePourGagner(JoueurOp, Grille1, _).
