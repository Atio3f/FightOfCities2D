##Capacites liés à un déplacement de l'unité
extends capacite
class_name mouvementCapacite

@export var nbrCases : int			#Nombre de cases nécessaires pour activer la compétence, si -1 alors ce n'est pas la condition pour la capacité
@export var compteurCase : int		#Compte le nombre de cases parcourt depuis la dernière activation

@export var casesActivables : Array = []	#Contient toutes les cases où la capacité s'active lorsque l'unité s'y déplace, si vide alors toutes les cases marchent
@export var passageCompte : bool = false	#Compte si le fait de passer sur une certaine case suffit à activer cette capacité
