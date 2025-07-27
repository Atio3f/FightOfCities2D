extends Resource
class_name parametresJoueur


@export var modeDaltonien : bool
@export var vitesseCamera : Array	#Contient une liste avec 2 valeurs, le x puis le y ex : [0.8, 1.5]
@export_range(0, 10) var volumeGeneral : int	#Enregistre les paramètres sonores du joueur
@export_range(0, 10) var volumeMusique : int
@export_range(0, 10) var volumeEffets : int
@export var touches : Dictionary	#On fera ça plus tard
