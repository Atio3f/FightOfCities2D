class_name unite
extends Path2D

@export var ressource : Resource	#On importe en ressource les stats de l'unité

@onready var sprite : Sprite2D = $PathFollow2D/SpriteUnite
@onready var contourSelec : Sprite2D = $PathFollow2D/ContourSelection


var positionUnite : Vector2

var pv_max : int
var pv_actuels : int :
	set(value):
		print(value)
		if value > pv_max :
			pv_actuels = pv_max
		if value <= 0 :
			print("L'unité de l'équipe ", couleurEquipe, " à la case", case ," a été tuée")
			mort() 
			return 0
		
@export var P : int		#Puissance permet de faire plus de dégâts
@export var DR : int		#DR ou Damage Reduction permet de réduire les dégâts subis à chaque attaque
@export var V : int		#Vitesse permet de se déplacer plus loin
@export var S : int		#Sagesse permet d'xp plus vite
@export_enum("Monkey", "Penguin","Chauve-Souris", "Autres") var race : String
@export_range(0, 30) var range : int
@export var couleurEquipe : String

var attaquesMax : int	#Le nombre d'attaques maximales réalisables par l'unité
var attaquesRestantes : int :	#Le nombre d'attaques qu'il reste à l'unité ce tour
	set(value):
		if value > attaquesMax :
			attaquesRestantes = attaquesMax
		else:
			attaquesRestantes = value

var vitesseRestante : int :
	set(value):
		if value > V :
			vitesseRestante = V
		else:
			vitesseRestante = value
var capacites : Dictionary	#Dictionnaire des capacités de l'unité(voir RessourceUniteBase pour comprendre la structure du dico)

var is_selected : bool = false:
	set(value):
		if(value == true):
			contourSelec.visible = true
		else:
			contourSelec.visible = false
		is_selected = value


var case : Vector2i = Vector2i.ZERO : #Case où se trouve l'unité sur le gridmap 
	set(value):
		# When changing the cell's value, we don't want to allow coordinates outside
		#	the grid, so we clamp them
		case = grid.grid_clamp(value)
		

## Shared resource of type Grid, used to calculate map coordinates.
@export var grid : Resource
@onready var _path_follow: PathFollow2D = $PathFollow2D

var _is_walking := false:
	set(value):
		_is_walking = value
		set_process(_is_walking)
		
signal signalFinMouvement
## Designate the current unit in a "wait" state
@export var is_wait := false

var typeDeplacementPossible : Array 	#La liste des moyens de déplacement possible par l'unité

var typeDeplacementActuel : String :		#Permet de savoir si l'unité est en train de voler ou non pour calculer les cases qu'il peut atteindre
	set(value):
		if typeDeplacementPossible.has(value) :
			typeDeplacementActuel = value
			



func _ready() -> void:
	sprite.texture = ressource.image
	
	#await get_tree().create_timer(3).timeout #Test temporaire du déplacement(fonctionne)
	#deplacement(Vector2(200, 80 ))
	
	set_process(true)
	_path_follow.rotates = false

	case = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(case)
	
	if not Engine.is_editor_hint():
		curve = Curve2D.new()
	
func placement(Equipe : String, newPosition : Vector2, positionCase : Vector2i, newRessource : Resource) -> void:
	print(Equipe)
	race = ressource.race
	if !Global._unitsTeam.has(Equipe):	#On crée une catégorie pour l'équipe si jamais elle n'existe pas encore. On les ajoute au début pour être certain de pouvoir y accéder pour les capacités
		Global._unitsTeam[Equipe] = {}
	print(Global._unitsTeam[Equipe].has(race))
	if !Global._unitsTeam[Equipe].has(race) : #On crée une catégorie pour la race de l'unité dans l'équipe si jamais elle n'existe pas
		Global._unitsTeam[Equipe][race] = []
	
	print(Global._unitsTeam)
	ressource = newRessource
	if ressource.capacites["PlacementBased"] != null :	#On check
		for capa in ressource.capacites["PlacementBased"]:
			2 +2 
			if capa[0] == "+":	#Check si le premier caractère de la capacité est un +
				var capaCible : PackedStringArray = capa.split("-", false)
				Global.buffEquipe(Equipe, "SpawnBuff", capaCible[1], capaCible[2],ressource.capacites["PlacementBased"][capa])
	
	pv_max = pv_max
	if ressource.pv_actuels > 0:	#Si les pv restants sont inférieurs ou égaux à 0 alors l'unité va mourir direct
		pv_actuels = ressource.pv_actuels
	else :
		pv_actuels = pv_max
	DR = ressource.DR
	P = ressource.P
	V = ressource.V
	S = ressource.S
	
	range = ressource.range
	attaquesMax = ressource.attaquesMax
	attaquesRestantes = ressource.attaquesRestantes
	if(ressource.couleurEquipe != ""):
		couleurEquipe = ressource.couleurEquipe
	
	typeDeplacementPossible = ressource.typeDeplacementPossible
	typeDeplacementActuel = ressource.typeDeplacementActuel
	
	
	position = newPosition	#Gestion de la position de l'unité
	case = positionCase
	print(positionCase)
	
	couleurEquipe = Equipe	#Equipe des ennemis
	Global._units[case]  = self
	print(couleurEquipe)
	
	Global._unitsTeam[couleurEquipe][race].append(self)
	
	
	
func deplacement(nouvellePosition : Vector2) -> void:
	position = nouvellePosition
	positionUnite = position


	
##Création de 2fonctions pour vérifier quelle unité se trouve à l'emplacement du pointeur de souris ##Sert pas à grand chose je crois
#func _on_zone_occupe_mouse_entered() -> void:
	#Global.unitOn = self
	#print(Global.unitOn)
#
#
#func _on_zone_occupe_mouse_exited() -> void:
	#Global.unitOn = null
	#print(Global.unitOn)
	

func _process(delta: float) -> void:
	_path_follow.progress += 1000 * delta
	if _path_follow.progress_ratio >= 1.0:
		_is_walking = false
		# Setting this value to 0.0 causes a Zero Length Interval error
		_path_follow.progress = 0.00001
		position = grid.calculate_map_position(case)
		curve.clear_points()
		emit_signal("signalFinMouvement")


## Starts walking along the `path`.
## `path` is an array of grid coordinates that the function converts to map coordinates.
func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
	
	case = path[-1]
	_is_walking = true
	
	


func boostStat(statUp : String, valeur : int):
	set(statUp, self.get(statUp) + valeur)
	
	

#Reçu depuis InterfaceFinTour, Est envoyé lorsque l'on change de tour et permet lorsque le tour qui commence est celui de l'unité de lui recharger ses mouvements
func nextTurn() -> void:
	if Global.ordreCouleur[Global.couleurTour] == couleurEquipe:
		vitesseRestante = V
		attaquesRestantes = attaquesMax
	

#Fonction lorsqu'une unité meurt, active les effets de mort de l'unité si elle en a puis fais disparaître l'unité du jeu
func mort() -> void :
	print(Global._units)
	Global._units.erase(case)	#On supprime l'unité du dictionnaire général des unités
	Global._unitsTeam[couleurEquipe][race].erase(self)	#On supprime l'unité du dictionnaire trié par équipe/race
	queue_free()	#Supprime l'unité
