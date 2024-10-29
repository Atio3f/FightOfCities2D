extends carteRessource
class_name cartePlacableRessource

@export var pv_max : int	#Equivalent de D + 20 qui servait à calculer les pv des unités avant ou 2*D + 30 pour les bâtiments avant
@export var pv_actuels : int
var pv_temporaires : int		#PV bonus qui ne peuvent pas être guéris, souvent obtenus depuis des objets et ne sont pas augmentés lorsque l'unité monte de niveau
@export var DR : int #Permet de réduire les dégâts subis(1DR = 1dégâts subi en moins par attaque)
@export var image : Texture		#Sprite de l'unité
@export var P : int		#Puissance permet de faire plus de dégâts
@export_enum("Physique", "Magique") var typeDegats : String	#Indique le type de dégâts qu'inflige l'unité avec ses attaques, permet de connaitre son type de défense
@export var V : int		#Vitesse permet de se déplacer plus loin

@export_range(0, 20) var range : int	#Distance d'attaque de l'unité
@export var attaquesMax : int	#Le nombre d'attaques maximales réalisables par l'unité
@export var attaquesRestantes : int 	#Le nombre d'attaques qu'il reste à l'unité ce tour
@export var vitesseRestante : int	#Le nombre de V qu'il reste à l'unité pour se déplacer

@export var typeDeplacementPossible : Array	#La liste des moyens de déplacement possible par l'unité.
											#Les possibilités sont : 
											#Les possibilités sont : 
											#- marche : Déplacement basique
											#- vole : tous les déplacements coûtent 2V
											#- tpMontagne : les montagnes sont toutes connectées pour l'unité(à voir si on met pas un rayon quand même)

@export_enum("marche", "vole", "aucun") var typeDeplacementActuel : String	#Permet de savoir si l'unité est en train de voler ou non pour calculer les cases qu'il peut atteindre
											# entre les différents éléments de typeDeplacementPossible


@export var listeCapacites : Array	#Contient toutes les capacités brutes de l'unité avant d'être calculer pour être transmises dans le dictionnaire capacité

##Capacités est un dictionnaire avec comme clé le moment où la capacité est utilisée et comme valeur une liste de toutes les capacités de l'unité :
	#Précision pour les clés :
	#PlacementBased = tout ce qui s'active lorsque l'unité est placée
	#PermanentBuff = tout les buffs qui durent tant que l'unité est en vie
	#ActiveCapacitiesBased = stock pratique de toutes les capacités qui nécessitent une activation manuelle lorsqu'on clique sur l'unité en question(servira pour l'interface)
	#TurnBased = tout ce qui s'active au début où à la fin des tours
	#ItemBased = tout ce qui s'active lorsque l'on utilise un objet sur l'unité
	#MovementBased = tout ce qui s'active lorsque l'unité bouge
	#AttackBased = tout ce qui s'active lorsque l'unité attaquez
	#KillBased = tout ce qui s'active lorsque l'unité tue une autre unité
	#DefenseBased = tout ce qui s'active lorsque l'unité prend des dégâts ou se fait attaquer
	#LevelUpBased = tout ce qui s'active lorsque l'unité monte de niveau
	#DeathBased = tout ce qui s'active quand l'unité meurt

@export var capacites : Dictionary = {
"PlacementBased" : {},
"PermanentBuff" : {}, 
"ActiveCapacitiesBased" : {},
"TurnBased" : {}, 
"ItemBased" : {}, 
"MovementBased" : {}, 
"AttackBased" : {}, 
"KillBased" : {},
"DefenseBased" : {}, 
"LevelUpBased" : {}, 
"DeathBased": {}
}

	#Composition d'une capacité active : clé =  "Operateur|StatsChangees|TypeCiblesOuSelf|LocalisationCibles(Around-1 = self, Around-n = autour à n cases, L-n = ligne de n cases, EW-1 = partout, EW-n = partout pour un nombre de cibles défini)|formeCiblage(une case C-1, carré de taille n C-n, une ligne de n largeur et m longuer l-n-m etc.. + possibilité de faire des &)" -> valeur = [nombreUtilisationsRestantes,durée(-1= infini), DescriptionCapa->s'ajoute à la liste de descript des capacités, valeurs pour chaque stat ] 

##Liste contenant les descriptions de toutes les capacités d'une unité PROBABLEMENT INUTILE AVEC LES NOUVELLES CLASSES CAPACITES
#@export var descriptionsCapa : Array 
