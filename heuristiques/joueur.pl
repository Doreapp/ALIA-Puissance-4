jouerJoueur(G,Joueur, N1, N2, Etat,Res) :- ecrit("Joueur joue ",1),ecrit(Joueur,1), ecrit(" entrez un nombre: ",1),
                                read(L), nth1(L,G,C), ajouter(C, Joueur, C1), changeColonne(G,L,C1,[],1,G1),
                                affiche(G1,[],Etat),
                                joueurOppose(Joueur, JoueurOp), heuristique(G1, JoueurOp, [N1|N2],Etat,Res). % gagnant()
