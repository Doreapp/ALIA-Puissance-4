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
 
 Niveau de l'IA:<br/>
 0: pas d'IA, joueur humain<br/>
 1: aléatoire<br/>
 2: s'il existe, joue un coup gagnant<br/>
 3: 2 + s'il existe, empèche un coup gagnant adverser<br/>
 4: 2 + 3 + joue un coup random sans donné un coup gagnant à l'adversaire<br/>
 5: 2 + 3 + MinMas statique<br/>
 <br/>
- Lancer un jeu :<br/>
 ``lancerJeu(arg1, arg2, Etat, Res).``<br/>
arg1: niv de l'IA du joueur 1<br/>
arg2: niv de l'IA du joueur 2<br/>
Etat: Spécifie si l'on souhaite un affichage du jeu ou non. (utile pour stats)<br/>
Res : Retourne le joueur gagnant<br/>
Ex  : ``lancerJeu(3,5,1,R).<br/>``
<br/>

 - Lancer une statistique<br/>
 Lance une statistique entre 2 IA (N1 et N2) sur 50 jeux<br/>
  ``stats(N1,N2,Cpt,J1,J2,Nul).``<br/>
 N1 : niv de l'IA du joueur 1<br/>
 N2 : niv de l'IA du joueur 2<br/>
 Cpt: Compteur du nombre de jeu. Compte jusqu'à 50<br/>
 J1 : Nombre de jeu gagner par le joueur 1<br/>
 J2 : Nombre de jeu gagner par le joueur 2<br/>
 Nul: Nombre de jeu nul<br/>
 Ex : ``stats(3,5,0,0,0,0).``
