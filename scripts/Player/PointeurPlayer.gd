extends Node2D

var aSelectionne : bool = false 
var Selection : cartePlacable		#Contiendra l'unité sélectionné
var target : Node2D

var positionSouris : Vector2i
var menuOpen : bool = false		#Permettra de savoir si un menu est ouvert, initialisé à false
@onready var caseSelec = $CaseSelecJ1
@onready var caseTarget = $CaseTargetJ1
@onready var position_cam = $"../Movement"
@onready var terrain = $"../../../Map/Terrain32x32"
@onready var scene = $"../.."			#On récupère la scène pour pouvoir plus tard récup les coord du curseur de la souris
@onready var map = $"../../../Map"



const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
var test : TileData
@export var cellSize : int = 32		#Pourra changer plus tard potentiellement


## Mapping of coordinates of a cell to a reference to the unit it contains.
#var _units := {}
#var _active_unit: unite		#_active_unit a été remplacé par pointeurSelec.Selection
var _walkable_cells := {}
var _attackable_cells := []
var actionCells := []	#Liste de toutes les cases accessibles avec une capa active depuis une unité
var _movement_costs : Array
var zoneCells : Array = [] #Liste de toutes les cases affectées par la capacité active
@onready var _unit_path: UnitPath = $UnitPathJ1
@onready var visuActions : UnitOverlay = $visualisationActionsJ
@onready var visuZoneCapa : UnitOverlay = $visualisationCapas
## Resource of type Grid.
@export var grid: Grid
const MAX_VALUE: int = 99999

var capaciteActuelle : activeCapacite = null
var caseAttaque : Vector2
var attaqueEnAttente : bool = false


func _ready() -> void:
	
	_movement_costs = terrain.get_movement_costs(grid)
	
	_reinitialize()
	
## Clears, and refills the `_units` dictionary with game objects that are on the board.
func _reinitialize() -> void:
	Global._units.clear()

	for child in get_children():
		var unit := child as unite
		if not unit:
			continue
		Global._units[unit.case] = unit

func _get_configuration_warning() -> String:
	var warning := ""
	if not grid:
		warning = "You need a Grid resource for this node to work."
	return warning


func _input(event) -> void:
	#Inutile gérer par Movement maintenant
	if event is InputEventMouseMotion:
		#var newPosition : Vector2i =  Vector2i(scene.get_global_mouse_position())/cellSize
		#
		##smoothyPosition()#Fonction qui centre les coords du curseur au centre d'une case
		#caseSelec.global_position = getMiddleMouseCell()					#On place caseSelec sur la case où se trouve la souris
		#if newPosition == positionSouris : 
			#positionSouris = newPosition			#On récupère la position de la souris par rapport au grillage et on divise par la taille des cellules
		##print(positionSouris)
		#print(positionSouris)
		#test = get_tile_data_at(positionSouris)				#Marche beaucoup mieux
		#if(test) :
			#print(test.get_custom_data("vitesseRequise"))
		pass
	else:
		if event.is_action_pressed("rightclick"):
			cursorPressed(positionSouris, "rightclick")
		else :
			if aSelectionne : 
				if event.is_action_pressed("leftClick"):
					cursorPressed(positionSouris, "leftClick")
			else : 
				if event.is_action_pressed("leftClick"):
					cursorPressed(positionSouris, "leftClick")


func _unhandled_input(event: InputEvent) -> void:
	if Selection and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()

#Permet de centrer les coords du curseur au centre d'une case NE SERVIRA PROBABLEMENT PLUS
func smoothyPosition() -> void:	
	positionSouris = Vector2i(positionSouris) / 32 * 32			#On met les coords de la souris dans un nouveau vecteur2i qui prend que
																	# des entiers(int) puis on divise par 32  avant de remultiplier par 32
																	# pour retirer le reste pour se retrouver en bas à gauche de la case 
																	#correspondante
	positionSouris = Vector2i(positionSouris.x + 16, positionSouris.y + 16)#On ajoute 16 à x et y pour se retrouver au centre de la case(ou 8 si on était sur du 16x16)



## Returns an array of cells a given unit can walk using the flood fill algorithm.
func get_walkable_cells(unit: unite) -> Dictionary:
	return _dijkstra(unit.case, unit.vitesseRestante, false, unit.typeDeplacementActuel)

## Return an array of cells a given unit can attack using dijkstra's and flood fill algorithm
func get_attackable_cells(unit: unite) -> Array:
	
	var attackable_cells = []
	var real_walkable_cells = _dijkstra(unit.case, unit.vitesseRestante, true, unit.typeDeplacementActuel)
	
	## iterate through every single cell and find their partners based on attack range(stat range)
	for curr_cell in real_walkable_cells:
		for curr_range in range(1, unit.range + 1):
			attackable_cells = attackable_cells + _flood_fill(curr_cell, unit.range)
	
	return attackable_cells.filter(func(i): return i not in real_walkable_cells)

## Returns an array with all the coordinates of walkable cells based on the `max_distance`.
func _flood_fill(cell: Vector2, max_distance: int) -> Array:
	var full_array := []
	var wall_array := []
	var stack := [cell]
	while not stack.size() == 0:
		var current = stack.pop_back()
		if not map.grid.is_within_bounds(current):
			continue
		if current in full_array:
			continue

		var difference: Vector2 = (current - cell).abs()
		var distance := int(difference.x + difference.y)
		if distance > max_distance:
			continue

		full_array.append(current)
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			
			###Sert à poser des cases infranchissables à faire plus tard si l'on en a besoin
			## This detects the impassable objects we define in the TileSet based on the Atlas ID
			## If you don't want units to attack over walls and only around them comment out this line and put 'continue'
			#if map.get_cell_source_id(0, coordinates) == OBSTACLE_ATLAS_ID:
				#wall_array.append(coordinates)
			
			#if is_occupied(coordinates):
			#	continue
			if coordinates in full_array:
				continue
			# Minor optimization: If this neighbor is already queued
			#	to be checked, we don't need to queue it again
			if coordinates in stack:
				continue
			
			stack.append(coordinates)
	
	## Filter out all the walls and return attackable cells
	return full_array.filter(func(i): return i not in wall_array)

## Generates a list of walkable cells based on unit movement value and tile movement cost
func _dijkstra(cell: Vector2i, max_distance: int, attackable_check: bool, typeDeplacement : String) -> Dictionary:	#typeDeplacement servira à influer sur les déplacements possibles(ex: vole change le coût de toutes les tuiles à 2)
	print("DIJKSTRA")
	var curr_unit = Global._units[cell]
	#moveable_cells est maintenant un dictionnaire avec comme clé les coords d'une case et en valeur le coût de déplacement vers cette case
	var movable_cells = {cell : 0} #Cellule où se trouve l'unité a un coût de 0 du coup
	var visited = [] # 2d array that keeps track of which cells we've already looked at while running the algorithm
	var distances = [] # shows distance to each cell, might be useful. can omit if you want to
	var previous = [] #2d array that shows you which cell you have to take to get there to get the shortest path. can omit if you want to
	## the previous array can be used to recontruct the path alogrithm found to the previous node you were at
	
	## iterate over width and height of the grid
	for y in range(grid.size.y):
		visited.append([])
		distances.append([])
		previous.append([])
		for x in range(grid.size.x):
			visited[y].append(false)
			distances[y].append(MAX_VALUE)
			previous[y].append(null)
	
	## Make new queue
	var queue = PriorityQueue.new()
	
	queue.push(cell, 0) #starting cell
	#print(distances[cell.y][cell.x])
	distances[cell.y][cell.x] = 0
	
	var tile_cost
	var distance_to_node
	var occupied_cells = []
	 
	## While there is still a node in the queue, we'll keep looping
	while not queue.is_empty():
		var current = queue.pop() #take out the front node
		visited[current.value.y][current.value.x] = true #mark front node as visited
		
		for direction in  DIRECTIONS:
			var coordinates = current.value + direction #Go through all four neighbors of current node
			var coordinatesI : Vector2i = coordinates	#On crée une copie de coordinates mais en Vector2i pour parcourir le dictionnaire _units plus tard
			if grid.is_within_bounds(coordinates):
				if visited[coordinates.y][coordinates.x]:
					continue
				else:
					
					if ( _movement_costs[coordinates.y].size() > coordinates.x ):	#Vérification que la case a une tuile
						tile_cost = _movement_costs[coordinates.y][coordinates.x]
					
						if typeDeplacement == "vole":
							distance_to_node = current.priority + 2 #le coût de la case est toujours égal à 2 pour une unité volante
						else :
							distance_to_node = current.priority + tile_cost #calculate tile cost normally
					
						## Check to see if tile is occupied by opposite team or is waiting
						## the "or _units[coordinates].is_wait" is the line that you will use to calculate 
						## Actual attack range for display on hover/walk
						#print(is_occupied(coordinatesI))
						if is_occupied(coordinatesI):
							#print(curr_unit.couleurEquipe)
							if curr_unit.couleurEquipe != Global._units[coordinatesI].couleurEquipe: #Remove this line if you want to make every unit impassable 
								distance_to_node = current.priority + MAX_VALUE #Mark enemy tile as impassable
							## remove this if you want attack ranges to be seen past units that are waiting METTRE elif si le if du dessus est décommentée
							elif Global._units[coordinatesI].is_wait and attackable_check:
								occupied_cells.append(coordinates)
						
						visited[coordinates.y][coordinates.x] = true
						distances[coordinates.y][coordinates.x] = distance_to_node
					else :
						distance_to_node = null
				
				if distance_to_node != null and distance_to_node <= max_distance: #check if node is actually reachable by our unit
					previous[coordinates.y][coordinates.x] = current.value #mark tile we used to get here
					#movable_cells.append({coordinates : distance_to_node}) #attach new node we are looking at as reachable
					movable_cells[coordinates] = distance_to_node
					queue.push(coordinates, distance_to_node) #use distance as priority
	
	#print(movable_cells)
	##On trie les localisations avant le return pour trier les clés à retirer avant 
	movable_cells.keys().filter(func(i): return i not in occupied_cells)
	return movable_cells


#Récupère la tuile à l'emplacement rentré en paramètre
func get_tile_data_at(emplacement : Vector2i) -> void:
	var local_position : Vector2i = terrain.local_to_map(positionSouris)			#On récupère l'information de la tuile où se trouve le pointeur de souris
	return terrain.get_cell_tile_data(0, local_position)

func getMiddleMouseCell() -> Vector2:
	var middleMouse : Vector2 = Vector2(positionSouris.x * 32 + 16, positionSouris.y * 32 + 16)
	return middleMouse


#On fait le calcul du nouvel emplacement dans Action. _hover_display et 
#Fonction s'active depuis Movement à chaque fois que le curseur bouge
func pointeurHasMove(new_cell: Vector2i) -> void:
	#print("PointeurHasMove")
	#print(_units.has(new_cell))
	#print(new_cell)
	#print(_units)
	## Updates the interactive path's drawing if there's an active and selected unit.
	if(!menuOpen):
		if Selection and Selection.is_selected:
			_unit_path.draw(Selection.case, new_cell)
			if Selection.attaquesRestantes > 0 and Global._units.has(new_cell) and Selection.couleurEquipe != Global._units[new_cell].couleurEquipe :
				print("TARGET")
				
				target = Global._units[new_cell]
				caseTarget.position = target.position
				caseTarget.visible = true
		elif visuActions != null and _walkable_cells != {}:
			_walkable_cells.clear() # Clearing out the walkable cells
			visuActions.clearNumbers() # This is what clears all the colored tiles on the grid
			visuZoneCapa.clearNumbers() # Clear l'affichage de la zone de la capacité
		if Global._units.has(new_cell) and Selection == null:
			_hover_display(new_cell)
	elif(capaciteActuelle != null):	#Ce qui se passe lorsque le joueur est en train d'activer la capa d'une unité et que son pointeur bouge
									#Affiche la zone affectée par la capa
		hoverZoneCapa(new_cell, capaciteActuelle)

## This function will display walkable_cells, attackable_cells, unit stats,
## Unit items, and the unit avatar (like in fire emblem: engage)
## That is the reason we make this a completely seperate function
func _hover_display(cell: Vector2i) -> void:
	var time = Time.get_ticks_msec()
	var curr_unit = Global._units[cell]
	
	## Acquire the walkable and attackable cells
	_walkable_cells = get_walkable_cells(curr_unit)
	
	_attackable_cells = get_attackable_cells(curr_unit)
	
	## Draw out the walkable and attackable cells now
	if(curr_unit.attaquesRestantes > 0) :
		visuActions.draw_attackable_cells(_attackable_cells)
	visuActions.draw_walkable_cells(_walkable_cells, curr_unit.couleurEquipe)
	print(Time.get_ticks_msec() - time)

## Fonction pour afficher la zone affectée par la capacité active
func hoverZoneCapa(cell: Vector2i, capaciteI : activeCapacite) -> void:
	
	
	##On clear les affichages des mouvements précédents avant d'en remettre sans toucher à la zone de la capa Active
	_walkable_cells.clear() 
	visuActions.clearNumbers()
	
	## Obtenir les cases affectées selon la forme et la taille ciblée par la capacité
	zoneCells = getCellsZoneCapa(cell, capaciteI)
	## Draw out the walkable and attackable cells now
	
	visuActions.draw_attackable_cells(zoneCells)
	
func getCellsZoneCapa(cell : Vector2i, capaciteI : activeCapacite) -> Array :
	var cells : Array = []
	
	
	
	##Check de la forme d'effet de la capa
	match(capaciteI.typeZone) :
		"EW" : #Si la portée de la compétence est de toute la map on utilise un autre calculateur
			cells.append(cell)
		"C" :
			var i = 0
			while(i < capaciteI.zoneEffet):
				#cells.append()
				i += 1
			
	return cells

## Selects or moves a unit based on where the cursor is.
func cursorPressed(cell: Vector2, typeClick : String) -> void:
	if not Selection:
		if(typeClick == "rightclick") :
			menuOpen = true
			visuActions.clearNumbers()
		else :	#Potentiellement inutile !
			menuOpen = false
		_select_unit(cell, menuOpen)
	elif Selection.is_selected:
		var cellI : Vector2i = cell
		if(!menuOpen):
			if(cell in _walkable_cells.keys()) :	#Si la case du pointeur se trouve dans les cases où peut se déplacer l'unité alors on la déplace
				_move_active_unit(cell)
			
			elif (cell in _attackable_cells and Selection.attaquesRestantes > 0 and Global._units.has(cellI) and Global._units[cellI].couleurEquipe != Selection.couleurEquipe):	#On vérifie qu'il y a une unité sur la case sélec, que l'unité qu'on a a encore des attaques à faire puis on vérifie que leurs couleurs sont différentes
				#print(Global._units)
				var casesAutourTarget : Array = _flood_fill(cell, Selection.range)
				print(casesAutourTarget)
				print(Selection.case)
				if casesAutourTarget.has(Vector2(Selection.case)) :
					Selection.attaque(Global._units[cellI])
					print("BON")
					_deselect_active_unit()
					_clear_active_unit()
				else :
					print("YRYREY")
					attaqueEnAttente = true
					visuActions.draw_attackable_cells([cellI])	#La seule case rouge affichée est celle de l'unité(à changer quand y'aura des attaques de zone)
					getTilesMouvementForAttaque(casesAutourTarget)
				
		elif(capaciteActuelle != null and Global._units.has(cellI)):	#Faudra changer plus tard la seconde partie pour permettre certaines activations sans unité
			declenchementCapaActive(cellI)

## Selects the unit in the `cell` if there's one there.
## Sets it as the `pointeurSelec.Selection` and draws its walkable cells and interactive move path. 
func _select_unit(cell: Vector2i, ouvrirMenu : bool) -> void:
	
	print("_select_unit")
	#print(cell)
	#print(Global._units)
	if not Global._units.has(cell):
		print(cell)
		print(Global._units)
		print("NON")
		return
	Selection = Global._units[cell]
	Selection.selectionneSelf(self, ouvrirMenu)
	
	## Acquire the walkable and attackable cells
	_walkable_cells = get_walkable_cells(Selection)
	_attackable_cells = get_attackable_cells(Selection)
	## Draw out the walkable and attackable cells now
	if(!menuOpen):
		if(Selection.attaquesRestantes > 0) :
			visuActions.draw_attackable_cells(_attackable_cells)
		visuActions.draw_walkable_cells(_walkable_cells, Selection.couleurEquipe)
	#var keysWalkableCells = _walkable_cells.keys()
		_unit_path.initialize(_walkable_cells)
	

## Returns `true` if the cell is occupied by a unit.
func is_occupied(cell: Vector2i) -> bool:
	return Global._units.has(cell)

## Updates the _units dictionary with the target position for the unit and asks the _active_unit to walk to it.
func _move_active_unit(new_cell: Vector2) -> void:
	
	var keysWalkableCells = _walkable_cells.keys()
	if is_occupied(new_cell) or not new_cell in keysWalkableCells:	#Check si le mouvement ne doit pas se dérouler
		return
	# warning-ignore:return_value_discarded
	Global._units.erase(Selection.case)
	print("BBOUT")
	#On crée 
	var newCelli : Vector2i = new_cell
	Global._units[newCelli] = Selection
	_deselect_active_unit()
	#On réduit la vitesse restante pour le tour pour l'unité qui se déplace
	Selection.vitesseRestante -= _walkable_cells[new_cell]
	Selection.walk_along(_unit_path.current_path)
	await Selection.signalFinMouvement
	print("finTT")
	
	_clear_active_unit()
	

## Deselects the active unit, clearing the cells overlay and interactive path drawing.
func _deselect_active_unit() -> void:
	print("deselect")
	
	Selection.deselectionneSelf(self)
	#pointeurSelec.Selection = null Complètement con de retirer l'unité avant de la faire finalement bouger puisqu'on ne l'a plus en mémoire
	visuActions.clearNumbers()
	visuZoneCapa.clearNumbers()
	_unit_path.stop()
	caseTarget.visible = false


## Clears the reference to the pointeurSelec.Selection and the corresponding walkable cells.
func _clear_active_unit() -> void:
	print("_clear_active_unit()")
	menuOpen = false	#On retire le fait qu'un menu est ouvert
	Selection = null
	capaciteActuelle = null	#On verra plus tard si ça pose pas de problème
	_walkable_cells.clear()




#Attributs : case <=> case de l'unité ; 
func get_actions_cells(case : Vector2i, capaPortee : int) -> Array :
	var distance : int = capaPortee		#distance nombre de cases de diamètre <=> unit.range 
	var action_cells = []
	
	var real_actions_cells = _dijkstra(case, distance * 2, false, "vole")	#Distance * 2 avec vole équivaut à un V par case 
	
	## iterate through every single cell and find their partners based on attack range(stat range)
	for curr_cell in real_actions_cells:
		for curr_range in range(1, distance + 1):
			action_cells = action_cells + _flood_fill(curr_cell, distance)
	
	return action_cells.filter(func(i): return i not in real_actions_cells)
	

#PAS FINI A RESTRUCTURER !!!
func capaActives(capaciteActivee : activeCapacite, uniteAssociee : Node2D) -> void:
	#var keyCapa : Array = capaciteActivee.keys()
	var capaPortee : String = capaciteActivee.typeZone
	if(capaciteActivee.typeZone == "EW") : #Si la portée de la compétence est de toute la map on utilise un autre calculateur
		actionCells = grid.toutesCases()
	else :
		actionCells = get_actions_cells(uniteAssociee.case, capaciteActivee.zoneEffet)
	capaciteActuelle = capaciteActivee
	visuZoneCapa.drawZoneAction(actionCells)	#Délocaliser dans declenchementCapaActive
	
	pass


func declenchementCapaActive(case : Vector2i) -> void :
	print("DECLENCHEMENT CAPACITE")
	
	
	#var contenuCapa : Array = Selection.capacites["ActiveCapacitiesBased"][capaciteActuelle.keys()[0]] #Plus rapide que de le retaper à chaque fois
	
	##Partie boucle pour chercher toutes les unités sur les cases affectées
	
	#Boucle pour tout ce qui se trouve dans la zone d'effet
	var typeCible : Array = capaciteActuelle.typeCible
	#Liste de toutes les cases où se trouvent une cible valide
	var cibles = filtreCible(zoneCells, typeCible, [Selection.couleurEquipe])		#A CHANGER Selection.couleurEquipe par l'Array de ses équipes alliées
	
	##Activation des effets pour chaque cible valide
	for cible in cibles :
		
		#Filtre du type d'effet de la capacité
		match(capaciteActuelle.operateur):
			"+" : 
				
				cible.boostStats(capaciteActuelle.statsAffectees)
				
	
	
	
	##Partie réduction du nombre du nombre d'utilisations restantes
	
	capaciteActuelle.nombreUtilisationsRestantes = capaciteActuelle.nombreUtilisationsRestantes - 1
	
	if(capaciteActuelle.nombreUtilisationsRestantes == 0):	#On supprime la capacité de l'unité lorsqu'elle n'a plus d'utilisations restantes
		Selection.capacites["ActiveCapacitiesBased"].erase(capaciteActuelle)
	
	##Reset de l'unité active et de sa sélection
	_deselect_active_unit()
	_clear_active_unit()



##Renvoie toutes les unités et bâtiments affectés par la capacité
func filtreCible(zoneCells : Array, typeCible : Array, equipesAlliees : Array) -> Array :
	##Déclaration liste retournée
	var cellsFiltrees := []
	##Vérification des conditions pour chaque cellule

	for case : Vector2i in zoneCells :
		var cible = Global._units[case]
		
		if(cible != null):
			
			for type in typeCible :
				print(type)
				##Check du bon type d'équipe visée par le ciblage
				if (type[-1] == 'E' and !equipesAlliees.has(cible.couleurEquipe)):
					
					pass
				elif (type[-1] != 'E' and equipesAlliees.has(cible.couleurEquipe)):
					
					if type == cible.race :	#A CHANGER faudra mettre différents critères de ciblage différents 
						cellsFiltrees.append(cible)
	
	return cellsFiltrees

##Permet d'obtenir les cases où l'unité doit se déplacer pour pouvoir attaquer
func getTilesMouvementForAttaque(casesAutourTarget : Array) -> void:
	var casesPossibles : Dictionary = {}
	var set_dict = {}
	for vec in casesAutourTarget:
		set_dict[vec] = true
	var tilesMouvementForAtt = []
	for vec in _walkable_cells:
		if vec in set_dict:
			casesPossibles[vec] = _walkable_cells[vec]
	visuActions.draw_walkable_cells(casesPossibles, "")
