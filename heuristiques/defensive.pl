% Heuristique 3 : s'il existe joue coup gagnant,
%                 sinon si l'adversaire à un coup gagnant, bloque le,
%                 sinon joue aléatoirement

movePourEmpecherGagner(JoueurJouant, JoueurAdverse, Grille, Grille1) :- jouerMove(JoueurAdverse, Grille, Coup, Grille2),
    gagner(JoueurAdverse, Grille2),
    jouerMove(JoueurJouant, Grille, Coup, Grille1).
