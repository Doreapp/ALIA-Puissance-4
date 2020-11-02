# ALIA-Puissance-4
Repo Prolog pour la 4IF : Puissance 4 

Quelques commandes git :
```
git branch [nomBranch]
git checkout [nomBranch]
git add [fichiers]
git commit -m "[message]" 
git push -u origin [nomBranch]


git log : 		pour voir les commit
git status : 	pour voir les changements avec origin
```
 # Main.pl
Lancer le jeu :
 ``lancerJeu(arg1, arg2).``
arg1: niv de l'IA du joueur 1
arg2: niv de l'IA du joueur 2

Niveau de l'IA:
 0: pas d'IA, joueur humain
 1: aléatoire
 2: s'il existe, joue un coup gagnant
 3: 2 + s'il existe, empèche un coup gagnant adverser
 4: 2 + 3 + joue un coup random sans donné un coup gagnant à l'adversaire
 5: 2 + 3 + MinMas statique
 
 # Stats.pl
Permet de faire des stats entre 2 heuristiques
Fichier à par car les affichages sont supprimés
Lancer une stats :
 ``stats(arg1,arg2,0,0,0,0).``
 arg1: niv de l'IA du joueur 1
 arg2: niv de l'IA du joueur 2
