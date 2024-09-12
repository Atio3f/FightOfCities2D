class_name unite
extends Path2D

@export var ressource : Resource	#On importe en ressource les stats de l'unité

@onready var sprite : Sprite2D = $ElementsUnite/SpriteUnite
@onready var contourSelec : Sprite2D = $ElementsUnite/ContourSelection
@onready var barreVie : Control = $ElementsUnite/InterfaceUnite	#La barre de vie affichée est changée lorsque l'unité perd ou gagne des pv ou pv max

var positionUnite : Vector2

var pv_max : int :
	set(value) :
		pv_max = value
		if(pv_actuels > pv_max) :	#Si les pv restants de l'unité dépassent ses pv max alors on les changent
			pv_actuels = pv_max
		barreVie.actualisationPV(self)

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
		barreVie.actualisationPV(self)
		
var pv_temporaires : int
@export var P : int		#Puissance permet de faire plus de dégâts
@export_enum("Physique", "Magique") var typeDegats : String	#Indique le type de dégâts qu'inflige l'unité avec ses attaques, permet de connaitre son type de défense


@export var DR : int		#DR ou Damage Reduction permet de réduire les dégâts subis à chaque attaque


@export var V : int		#Vitesse permet de se déplacer plus loin


@export var S : int		#Sagesse permet d'xp plus vite
@export_range(1, 3) var niveau : int :	#Le niveau de l'unité. Les niveaux 2 et 3 donnent chacun 50% de pv bonus ainsi que n DR avec n = niveau
	set(value):
		
		if (niveau - value) > 1  || (niveau - value) < -1:	#On ne peut pas retirer + d'un niveau à la fois
			print("On ne peut pas retirer ou rajouter plus d'un niveau à la fois")
			return null
		elif niveau - value == 1 :	#On retire les gains d'un niveau lorsqu'on le perd
			DR -= niveau
			pv_max = pv_max / 1.5
			for capa in capacites["LevelUpBased"] :	#Servira lorsqu'il y aura des unités qui se boost à chaque montée de niveau pour leur retirer en cas de perte de niveau
				pass
			niveau = value
		else :				#On rajoute les gains d'un niveau lorsqu'on en gagne un
			niveau = value
			pv_max = pv_max * 1.5
			DR += niveau
			for capa in capacites["LevelUpBased"] :		#Servira lorsqu'il y aura des unités qui se boost à chaque montée de niveau
				pass
				
const paliersNiveaux = [0, 100, 250]	#L'expérience nécessaire pour monter au niveau 2(100) puis pour monter au niveau 3(250)

@export var experience : float :#L'expérience obtenue par l'unité (Le calcul est : dégâts infligés + S lors d'une attaque, la moitié de ça lorsqu'elle prend des dégâts et pv unité tuée + 2S lors d'un kill
	set(value):
		if(race == "taureaux"):
			print("EXPE")
			print(value)
		
		while (value > paliersNiveaux[niveau + 1]):	#Tant que l'unité peut monter de niveau avec l'experience obtenue on continue
		
			niveau += 1
		experience = value


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
@onready var _path_follow: PathFollow2D = $ElementsUnite

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
			

@onready var noeudsTempIndic : Node2D = $NoeudsTemp/IndicDegats	#Sert au stockage de tous les noeuds qui disparaissent(ex  popUpDegats)
var popUpDegats = preload("res://nodes/Unite/interfaceUnite/indicateur_degats.tscn")	#L'indicateur de dégâts lors d'une attaque(utilisé dans subirDegats)
 

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
	#print(Equipe)
	ressource = newRessource
	race = ressource.race
	if !Global._unitsTeam.has(Equipe):	#On crée une catégorie pour l'équipe si jamais elle n'existe pas encore. On les ajoute au début pour être certain de pouvoir y accéder pour les capacités
		Global._unitsTeam[Equipe] = {}
	#print(Global._unitsTeam[Equipe].has(race))
	if !Global._unitsTeam[Equipe].has(race) : #On crée une catégorie pour la race de l'unité dans l'équipe si jamais elle n'existe pas
		Global._unitsTeam[Equipe][race] = []
	
	#print(Global._unitsTeam)
	if ressource.capacites["PlacementBased"] != null :	#On check
		for capa in ressource.capacites["PlacementBased"]:
			2 +2 
			if capa[0] == "+":	#Check si le premier caractère de la capacité est un +
				var capaCible : PackedStringArray = capa.split("-", false)
				Global.buffEquipe(Equipe, "SpawnBuff", capaCible[1], capaCible[2],ressource.capacites["PlacementBased"][capa])
	
	pv_max = ressource.pv_max
	if ressource.pv_actuels > 0:	#Si les pv restants sont inférieurs ou égaux à 0 alors l'unité va mourir direct
		pv_actuels = ressource.pv_actuels
		
		
	else :
		pv_actuels = pv_max
	pv_temporaires = ressource.pv_temporaires
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
	#print(positionCase)
	
	couleurEquipe = Equipe	#Equipe des ennemis
	Global._units[case]  = self
	#print(couleurEquipe)
	
	Global._unitsTeam[couleurEquipe][race].append(self)
	sprite.texture = ressource.image
	capacites = ressource.capacites
	
	
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
	

signal signalFinAttaque()	#Potentiellement rajouter des infos sur si un kill a été fait ou non
func attaque(uniteAttaque : Node2D) -> Signal:
	var totalDegats : int = P	#Les dégâts de base sont égaux à P
	for capa in capacites["AttackBased"]:
		pass
	uniteAttaque.estAttaque(self, totalDegats)	#On envoie les infos de dégâts
	attaquesRestantes = attaquesRestantes - 1	#On retire une attaque à l'unité 
	return signalFinAttaque
	

func estAttaque(attaquant : Node2D, degats : int) -> void :
	print(degats)
	
	if(subirDegats(degats, attaquant.typeDegats)) :
		if(attaquant.get_class() == "unite") :	#Préparation à l'arrivée des bâtiments et sorts
			attaquant.getKill(self)
		
		mort(attaquant)
	else :	#Si l'unité n'est pas morte avec cette attaque alors elle gagne de l'expérience
		experience = experience + ((degats + S) /2)

#Fonction servant à faire le décompte des pv, typeDegatsAttaquant indique le type de dégâts de l'attaque avant de renvoyer si l'unité est morte ou non
func subirDegats(degats : int, typeDegatsAttaquant : String) -> bool :
	print(pv_actuels)
	var totalDegats : int = degats
	if (typeDegatsAttaquant == typeDegats) :
		totalDegats -= DR / 5
	
	if(pv_temporaires < totalDegats):	#Si les dégâts subis sont inférieurs aux pv_temporaires on ne change que pv_temporaires
		pv_temporaires = 0
		pv_actuels = pv_actuels - totalDegats
	else :
		pv_temporaires -= totalDegats
	print(pv_actuels)
	var indicDegats : Node2D = popUpDegats.instantiate()	
	noeudsTempIndic.add_child(indicDegats)		#Place l'indicateur de dégâts sur la scène
	indicDegats.newPopUp(totalDegats)
	
	print("PVS")
	print(indicDegats)
	return (pv_actuels <= 0) #On vérifie si l'unité est morte

func getKill(unitTuee : unite) -> void:
	experience = experience + unitTuee.pv_max + (2 * S)
	for capa in capacites["KillBased"]:
		pass

#Fonction lorsqu'une unité meurt, active les effets de mort de l'unité si elle en a puis fais disparaître l'unité du jeu
func mort(attaquant : unite) -> void :
	Global._units.erase(case)	#On supprime l'unité du dictionnaire général des unités
	Global._unitsTeam[couleurEquipe][race].erase(self)	#On supprime l'unité du dictionnaire trié par équipe/race
	
	if(noeudsTempIndic.get_child_count(false)!=0):	#Si il reste des éléments à afficher dans les indicateurs de dégâts on lance un chrono de 1sec pour attendre
		_path_follow.visible = false	#On retire tous les éléments de l'unité pour ne laisser que les éléments temporaires de visible
		await get_tree().create_timer(1.2).timeout
	
	queue_free()	#Supprime l'unité
