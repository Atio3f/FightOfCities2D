extends carte
class_name cartePlacable

@onready var capacites : gestionnaireCapacites = $GestionCapacites

@onready var sprite : Sprite2D = $ElementsUnite/SpriteUnite
@onready var interfaceUnite : Control = $ElementsUnite/InterfaceUnite	#La barre de vie affichée est changée lorsque l'unité perd ou gagne des pv ou pv max

## Shared resource of type Grid, used to calculate map coordinates.
@export var grid : Resource
@onready var _path_follow: PathFollow2D = $ElementsUnite

@onready var noeudsTempIndic : Node2D = $NoeudsTemp/IndicDegats	#Sert au stockage de tous les noeuds qui disparaissent(ex  popUpDegats)
var popUpDegats = preload("res://nodes/Unite/interfaceUnite/indicateur_degats.tscn")	#L'indicateur de dégâts lors d'une attaque(utilisé dans subirDegats)
 

var positionUnite : Vector2
var imageUnit : Texture :
	set(value):
		sprite.texture = value
		imageUnit = value
var pv_max : int :
	set(value) :
		pv_max = value
		if(pv_actuels > pv_max) :	#Si les pv restants de l'unité dépassent ses pv max alors on les changent
			pv_actuels = pv_max
		interfaceUnite.actualisationPV(self)

var pv_actuels : int :
	set(value):
		print("SETTER")
		print(value)
		print(pv_actuels)
		if value > pv_max :	#Si la nouvelle valeur de pv_actuels dépasse le max de pv alors on 
			pv_actuels = pv_max
		else :
			pv_actuels = value
		if value <= 0 :		#Indique que l'unité est morte
			print("L'unité de l'équipe ", couleurEquipe, " à la case", case ," a été tuée")
		print(pv_actuels)
		interfaceUnite.actualisationPV(self)

var pv_temporaires : int

@export var P : int		#Puissance permet de faire plus de dégâts
@export_enum("Physique", "Magique") var typeDegats : String	#Indique le type de dégâts qu'inflige l'unité avec ses attaques, permet de connaitre son type de défense


@export var DR : int		#DR ou Damage Reduction permet de réduire les dégâts subis à chaque attaque


@export var V : int		#Vitesse permet de se déplacer plus loin
@export var couleurEquipe : String

var case : Vector2i = Vector2i.ZERO : #Case où se trouve l'unité sur le gridmap 
	set(value):
		# When changing the cell's value, we don't want to allow coordinates outside
		#	the grid, so we clamp them
		case = grid.grid_clamp(value)


#Fonction servant à faire le décompte des pv, typeDegatsAttaquant indique le type de dégâts de l'attaque avant de renvoyer les dégâts après réductions
func subirDegats(degats : int, typeDegatsAttaquant : String) -> int :
	
	var totalDegats : int = degats
	if (typeDegatsAttaquant == typeDegats) :
		totalDegats -= DR / 5
	
	if(pv_temporaires < totalDegats):	#Si les dégâts subis sont inférieurs aux pv_temporaires on ne change que pv_temporaires
		pv_temporaires = 0
		pv_actuels = pv_actuels - totalDegats
	else :
		pv_temporaires -= totalDegats
	
	var indicDegats : Node2D = popUpDegats.instantiate()	
	noeudsTempIndic.add_child(indicDegats)		#Place l'indicateur de dégâts sur la scène
	indicDegats.newPopUp(totalDegats)
	
	
	
	return totalDegats #On renvoie les vrais dégâts pour le calcul de l'xp gagné par l'attaquant
