
extends cartePlacable
class_name unite

@export var ressource : uniteRessource	#On importe en ressource les stats de l'unité

@onready var contourSelec : Sprite2D = $ElementsUnite/ContourSelection





@export var S : int		#Sagesse permet d'xp plus vite
@export_range(1, 3) var niveau : int :	#Le niveau de l'unité. Les niveaux 2 et 3 donnent chacun 50% de pv bonus ainsi que n DR avec n = niveau
	set(value):
		
		if (niveau - value) > 1  || (niveau - value) < -1:	#On ne peut pas retirer + d'un niveau à la fois
			print("On ne peut pas retirer ou rajouter plus d'un niveau à la fois")
			return null
		elif niveau - value == 1 :	#On retire les gains d'un niveau lorsqu'on le perd
			DR -= niveau
			pv_max = pv_max / 1.5
			for capa in capacites.getCapasFrom("LevelUpBased")  :	#Servira lorsqu'il y aura des unités qui se boost à chaque montée de niveau pour leur retirer en cas de perte de niveau
				pass
			niveau = value
		else :				#On rajoute les gains d'un niveau lorsqu'on en gagne un
			niveau = value
			pv_max = pv_max * 1.5
			pv_actuels = pv_actuels + pv_max / 3
			DR += niveau
			for capa in capacites.getCapasFrom("LevelUpBased") :		#Servira lorsqu'il y aura des unités qui se boost à chaque montée de niveau
				pass
				
const paliersNiveaux = [0, 100, 250, 99999]	#L'expérience nécessaire pour monter au niveau 2(100) puis pour monter au niveau 3(250)

@export var XP : float :#L'expérience obtenue par l'unité (Le calcul est : dégâts infligés + S lors d'une attaque, la moitié de ça lorsqu'elle prend des dégâts et pv unité tuée + 2S lors d'un kill
	set(value):
		
		while (value > paliersNiveaux[niveau + 1]):	#Tant que l'unité peut monter de niveau avec l'experience obtenue on continue
		
			niveau += 1
		XP = value


@export_enum("Monkey", "Penguin","Chauve-Souris", "Autres") var race : String
@export_range(0, 30) var range : int


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

var is_selected : bool = false:
	set(value):
		if(value == true):
			contourSelec.visible = true
		else:
			contourSelec.visible = false
		is_selected = value

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
	print(self.name)
	sprite.texture = ressource.image
	interfaceUnite._entiteeAssociee = self
	
	#await get_tree().create_timer(3).timeout #Test temporaire du déplacement(fonctionne)
	#deplacement(Vector2(200, 80 ))
	
	set_process(true)
	_path_follow.rotates = false

	case = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(case)
	
	%CouleurEquipe.color = Global.colorSelector(couleurEquipe)
	if not Engine.is_editor_hint():
		curve = Curve2D.new()
	
func placement(Equipe : String, newPosition : Vector2, positionCase : Vector2i, newRessource : uniteRessource) -> void:
	#print(Equipe)
	ressource = newRessource
	typeCarte = ressource.typeCarte
	race = ressource.race
	if(ressource.couleurEquipe != ""):
		print("TESY")
		couleurEquipe = ressource.couleurEquipe
		
	else :
		couleurEquipe = Equipe	#Equipe des ennemis
	%CouleurEquipe.color = Global.colorSelector(couleurEquipe)
	
	if !Global._unitsTeam.has(Equipe):	#On crée une catégorie pour l'équipe si jamais elle n'existe pas encore. On les ajoute au début pour être certain de pouvoir y accéder pour les capacités
		Global._unitsTeam[Equipe] = {}
	#print(Global._unitsTeam[Equipe].has(race))
	if !Global._unitsTeam[Equipe].has(race) : #On crée une catégorie pour la race de l'unité dans l'équipe si jamais elle n'existe pas
		Global._unitsTeam[Equipe][race] = []
	
	capacites.initialisationCapas(ressource.listeCapacites)
	#print(Global._unitsTeam)
	
	for capa : capacite in capacites.getCapasFrom("PlacementBased"):
		
		match(capa.operateur):
			"+":	#Check si le premier caractère de la capacité est un +
				
				Global.buffEquipe(couleurEquipe, "SpawnBuff", capa.statsAffectees, capa.typeCible, 1)
			"-":	#Check si le premier caractère de la capacité est un -
				
				Global.buffEquipe(couleurEquipe, "SpawnBuff", capa.statsAffectees, capa.typeCible, -1)

	pv_max = ressource.pv_max
	if ressource.pv_actuels > 0:	#Si les pv restants sont inférieurs ou égaux à 0 alors l'unité va mourir direct
		pv_actuels = ressource.pv_actuels
		
		
	else :
		pv_actuels = pv_max
	pv_temporaires = ressource.pv_temporaires

	DR = ressource.DR + Global.equipesData[couleurEquipe]["SpawnBuff"][race][1]
	P = ressource.P + Global.equipesData[couleurEquipe]["SpawnBuff"][race][2]
	V = ressource.V + Global.equipesData[couleurEquipe]["SpawnBuff"][race][3]
	S = ressource.S + Global.equipesData[couleurEquipe]["SpawnBuff"][race][4]
	
	range = ressource.range
	attaquesMax = ressource.attaquesMax
	attaquesRestantes = ressource.attaquesRestantes
	
	typeDeplacementPossible = ressource.typeDeplacementPossible
	typeDeplacementActuel = ressource.typeDeplacementActuel
	
	position = newPosition	#Gestion de la position de l'unité
	case = positionCase
	#print(positionCase)
	
	
	Global._units[case]  = self
	#print(couleurEquipe)
	
	Global._unitsTeam[couleurEquipe][race].append(self)
	imageUnit = ressource.image
	description = ressource.description
	

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
	
	_path_follow.progress += 10 * grid.cellSize.x * delta
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

	match(statUp):
		"V":
			if(valeur < 0) :	#Evite que l'on perde un VitesseRestante à cause des limites faites du setter de V
				set("vitesseRestante", self.get(statUp) + valeur)
				set(statUp, self.get(statUp) + valeur)
			else :
				set(statUp, self.get(statUp) + valeur)
				set("vitesseRestante", self.get(statUp) + valeur)
		
		_:
			set(StringName(statUp), self.get(statUp) + valeur)

func boostStats(statsUp : Dictionary):
	var i : int = 0		#Compteur num élément pour obtenir sa valeur
	for statUp : String in statsUp :
		
		match(statUp):
			"V":
				
				if(statsUp[statUp] < 0) :	#Evite que l'on perde un VitesseRestante à cause des limites faites du setter de V
					set("vitesseRestante", self.get(statUp) + statsUp[statUp])
					set(statUp, self.get(statUp) + statsUp[statUp])
				else :
					set(statUp, self.get(statUp) + statsUp[statUp])
					set("vitesseRestante", self.get(statUp) + statsUp[statUp])
			
			_:
				print(statsUp[statUp])
				print(self.get(statUp))
				set(statUp, self.get(statUp) + statsUp[statUp])
		i += 1


#Reçu depuis InterfaceFinTour, Est envoyé lorsque l'on change de tour et permet lorsque le tour qui commence est celui de l'unité de lui recharger ses mouvements
func nextTurn() -> void:
	if Global.ordreCouleur[Global.couleurTour] == couleurEquipe:
		vitesseRestante = V
		attaquesRestantes = attaquesMax
	

signal signalFinAttaque()	#Potentiellement rajouter des infos sur si un kill a été fait ou non


func attaque(uniteAttaque : Node2D) -> Signal:
	var totalDegats : int = P	#Les dégâts de base sont égaux à P
	for capa in capacites.getCapasFrom("AttackBased"):
		pass
	
	uniteAttaque.estAttaque(self, totalDegats)	#On envoie les infos de dégâts
	attaquesRestantes = attaquesRestantes - 1	#On retire une attaque à l'unité 
	
	
	return signalFinAttaque
	

func estAttaque(attaquant : Node2D, degats : int) -> void :
	
	## + Stocke des dégâts subis au final pour les ajouter à l'attaquant
	var totalDegats = subirDegats(degats, attaquant.typeDegats)
	##Gain d'xp pour l'attaquant 
	attaquant.XP = attaquant.XP + (totalDegats * 0.75 + attaquant.S)
	
	##Vérification de la mort ou non de l'unité
	
	
	if(pv_actuels <= 0) :
		if(attaquant.typeCarte == "Unite") :	#Préparation à l'arrivée des bâtiments et sorts
			
			attaquant.getKill(self)
		
		mort(attaquant)
	else :	#Si l'unité n'est pas morte avec cette attaque alors elle gagne de l'expérience
		XP = XP + ((degats + S) /2)


func getKill(unitTuee : unite) -> void:
	XP = XP + unitTuee.pv_max + (2 * S)
	for capa in capacites.getCapasFrom("KillBased"):
		pass

#Fonction qui s'active lorsque l'unité est sélectionnée
func selectionneSelf(pointeurJoueurI : pointeurJoueur, menuOpen : bool):
	if(menuOpen):	#On n'affiche le menu que lorsque le pointeur du joueur que lorsqu'on fait un click droit
		interfaceUnite.apercuMenusUnite(self, pointeurJoueurI, true)
	is_selected = true
	
	
#Cache le menu dans l'interface de l'unité et seslorsque l'unité est déselectionnée
func deselectionneSelf(pointeurJoueurI : pointeurJoueur):
	
	interfaceUnite.apercuMenusUnite(self, pointeurJoueurI, false)
	is_selected = false

#Fonction lorsqu'une unité meurt, active les effets de mort de l'unité si elle en a puis fais disparaître l'unité du jeu
func mort(attaquant : unite) -> void :
	Global._units.erase(case)	#On supprime l'unité du dictionnaire général des unités
	Global._unitsTeam[couleurEquipe][race].erase(self)	#On supprime l'unité du dictionnaire trié par équipe/race
	
	
	for capa : capacite in capacites.getCapasFrom("DeathBased"):
		
		match(capa.operateur):
			"+":	#Check si le premier caractère de la capacité est un +
				
				Global.buffEquipe(couleurEquipe, "SpawnBuff", capa.statsAffectees, capa.typeCible, 1)
			"-":	#Check si le premier caractère de la capacité est un -
				
				Global.buffEquipe(couleurEquipe, "SpawnBuff", capa.statsAffectees, capa.typeCible, -1)

	if(noeudsTempIndic.get_child_count(false)!=0):	#Si il reste des éléments à afficher dans les indicateurs de dégâts on lance un chrono de 1sec pour attendre
		_path_follow.visible = false	#On retire tous les éléments de l'unité pour ne laisser que les éléments temporaires de visible
		await get_tree().create_timer(1.2).timeout
	
	queue_free()	#Supprime l'unité





func _on_interface_unite_focus_entered():
	print("KOK")
