extends Node2D
class_name pointeurJoueur

var aSelectionne : bool = false 
var Selection : AbstractUnit		#Contiendra l'unité sélectionné
var target : AbstractUnit

var positionSouris : Vector2i
var menuOpen : bool = false		#Permettra de savoir si un menu est ouvert, initialisé à false
@onready var caseSelec : Sprite2D = $CaseSelecJ1
@onready var caseTarget : Sprite2D = $CaseTargetJ1
@onready var position_cam : Camera2D = $"../Movement"
@onready var terrain: Terrain = $"../../../Map/Terrain512x512"
@onready var scene := $"../.."			#On récupère la scène pour pouvoir plus tard récup les coord du curseur de la souris
@onready var map := $"../../../Map"
@onready var interfaceJoueurI : interfaceJoueur= $"../CanvasInterfaceViewport/interfaceJoueur"


const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
var test : TileData
#@export var cellSize : int = 512		#Pourra changer plus tard potentiellement, on utilise celui de Global plutôt je pense


## Mapping of coordinates of a cell to a reference to the unit it contains.
#var _units := {}
#var _active_unit: unite		#_active_unit a été remplacé par pointeurSelec.Selection
var _walkable_cells := {}
var _attackable_cells : Array[Vector2i] = []
var actionCells := []	#Liste de toutes les cases accessibles avec une capa active depuis une unité
var attaqueEnAttenteCells := {}#Liste des cases où peut se déplacer l'unité pour accomplir l'attaque sélectionnée
var _movement_costs : Array
var zoneCells : Array = [] #Liste de toutes les cases affectées par la capacité active
@onready var _unit_path: UnitPath = $UnitPathJ1
@onready var visuActions : UnitOverlay = $visualisationActionsJ
@onready var visuZoneCapa : UnitOverlay = $visualisationCapas
@onready var visuPlacement : VisualisationPlacement = $visualisationPlacement
const MAX_VALUE: int = 99999

var capaciteActuelle : AbstractCapacity = null
var caseAttaque : Vector2
var attaqueEnAttente : bool = false

#func _process(delta):
	#print(menuOpen)

func _ready() -> void:
	
	refreshMap()
	
	_reinitialize()

#Use to refresh the cost of each tile
func refreshMap(movementType: MovementTypes.movementTypes = MovementTypes.movementTypes.WALK) -> void :
	_movement_costs = MapManager.get_movement_costs(movementType)


## Clears, and refills the `_units` dictionary with game objects that are on the board.
func _reinitialize() -> void:
	1
	##A RETIRER
	#Global._units.clear()
	#for child in get_children():
		#var unit := child as unite
		#if not unit:
			#continue
		#Global._units[unit.case] = unit

	##A RETIRER on utilise plus de grid
#func _get_configuration_warning() -> String:
	#var warning := ""
	#if not grid:
		#warning = "You need a Grid resource for this node to work."
	#return warning


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
	if event.is_action_pressed("ui_cancel"):
		if Selection :	#On ne déselectionne l'unité uniquement si il y en a une de sélectionner pour éviter des problèmes
			_deselect_active_unit()
		_clear_active_unit()	#N'est pas inclus dans le if pour permettre la fermeture de l'interface d'utilisateur également
	

#Permet de centrer les coords du curseur au centre d'une case NE SERVIRA PROBABLEMENT PLUS
func smoothyPosition() -> void:	
	positionSouris = Vector2i(positionSouris) / 512 * 512			#On met les coords de la souris dans un nouveau vecteur2i qui prend que
																	# des entiers(int) puis on divise par 512  avant de remultiplier par 512
																	# pour retirer le reste pour se retrouver en bas à gauche de la case 
																	#correspondante
	positionSouris = Vector2i(positionSouris.x + 256, positionSouris.y + 256)#On ajoute 256 à x et y pour se retrouver au centre de la case(ou 8 si on était sur du 16x16)



## Returns an array of cells a given unit can walk using the flood fill algorithm.
func get_walkable_cells(unit: AbstractUnit) -> Dictionary:
	return GridUtils.get_walkable_cells(unit)

## Return an array of cells a given unit can attack using dijkstra's and flood fill algorithm
func get_attackable_cells(unit: AbstractUnit) -> Array[Vector2i]:
	return GridUtils.get_attackable_cells(unit)

## Returns an array with all the coordinates of walkable cells based on the `max_distance`.
func _flood_fill(cell: Vector2i, max_distance: int) -> Array[Vector2i]:
	return GridUtils.flood_fill(cell, max_distance)

## Generates a list of walkable cells based on unit movement value and tile movement cost
func _dijkstra(cell: Vector2i, max_distance: int, attackable_check: bool, movementType : MovementTypes.movementTypes, unit: AbstractUnit = null) -> Dictionary:
	return GridUtils.dijkstra(cell, max_distance, attackable_check, movementType, unit)


#Récupère la tuile à l'emplacement rentré en paramètre
func get_tile_data_at(emplacement : Vector2i) -> void:
	var local_position : Vector2i = terrain.local_to_map(positionSouris)			#On récupère l'information de la tuile où se trouve le pointeur de souris
	return terrain.get_cell_tile_data(local_position)

func getMiddleMouseCell() -> Vector2:
	var middleMouse : Vector2 = Vector2(positionSouris.x * 512 + 256, positionSouris.y * 512 + 256)
	return middleMouse


#On fait le calcul du nouvel emplacement dans Action. _hover_display et 
#Fonction s'active depuis Movement à chaque fois que le curseur bouge
func pointeurHasMove(new_cell: Vector2i) -> void:
	#print("PointeurHasMove")
	#print(_units.has(new_cell))
	#print(new_cell)
	#print(_units)
	## Updates the interactive path's drawing if there's an active and selected unit.
	var tileOn: AbstractTile = MapManager.getTileAt(new_cell)
	caseSelec.visible = tileOn != null	#Hide the pointeur if we're out of bounds
	if(!menuOpen):
		if Selection and Selection.is_selected:
			_unit_path.draw(Selection.tile.getCoords(), new_cell)
			if Selection.atkRemaining > 0 and tileOn != null and tileOn.hasUnitOn() and Selection.team != tileOn.unitOn.team :
				print("TARGET")
				
				target = tileOn.unitOn
				caseTarget.position = target.position
				caseTarget.visible = true
			else :					#On cache l'indicateur de ciblage si il n'y a aucune cible sur la case actuelle
				caseTarget.visible = false
		elif visuActions != null and _walkable_cells != {}:
			_walkable_cells.clear() # Clearing out the walkable cells
			visuActions.clearNumbers() # This is what clears all the colored tiles on the grid
			visuZoneCapa.clearNumbers() # Clear l'affichage de la zone de la capacité
		### A SUPPRIMER if Global._units.has(new_cell) and Selection == null:
		if MapManager.getTileAt(new_cell) != null && MapManager.getTileAt(new_cell).hasUnitOn() and Selection == null:
			_hover_display(new_cell)
			
	elif(capaciteActuelle != null):	#Ce qui se passe lorsque le joueur est en train d'activer la capa d'une unité et que son pointeur bouge
		#Affiche la zone affectée par la capa si elle la change selon la souris (plus tard)
		pass

## This function will display walkable_cells, attackable_cells, unit stats,
## Unit items, and the unit avatar (like in fire emblem: engage)
## That is the reason we make this a completely seperate function
func _hover_display(cell: Vector2i) -> void :
	var time : int = Time.get_ticks_msec()
	var currTile: AbstractTile = MapManager.getTileAt(cell)
	var curr_unit = currTile.unitOn
	if curr_unit == null : return
	## Acquire the walkable and attackable cells
	_walkable_cells = get_walkable_cells(curr_unit)
	
	_attackable_cells = get_attackable_cells(curr_unit)
	## Draw out the walkable and attackable cells now
	if(curr_unit.atkRemaining > 0) :
		visuActions.draw_attackable_cells(_attackable_cells)
	visuActions.draw_walkable_cells(_walkable_cells, curr_unit.team)


## Selects or moves a unit based on where the cursor is.
func cursorPressed(cell: Vector2i, typeClick : String) -> void:
	if %MetaUI.visible : return
	#print(typeClick)
	if not Selection:
		if(typeClick == "rightclick") :
			menuOpen = true
			visuActions.clearNumbers()
			
		#else :	#Potentiellement inutile !
			#menuOpen = false
		_select_unit(cell, menuOpen, typeClick)
		
	elif Selection.is_selected:
		var cellI : Vector2i = cell
		#Can't move or attack with an unit outside its turn
		if Selection.team != TurnManager.actualTurn() : return
		if(!menuOpen):
			#print(_walkable_cells)
			#print(cell in _walkable_cells)
			#print(_attackable_cells)
			#print(cell in _attackable_cells)
			var tileOn: AbstractTile = MapManager.getTileAt(cellI)
			var unitOnTile: AbstractUnit
			if tileOn != null : unitOnTile = tileOn.unitOn 
			else : unitOnTile = null
			if(cell in _walkable_cells.keys()) :	#Si la case du pointeur se trouve dans les cases où peut se déplacer l'unité alors on la déplace
				print("MOUVEMENT")
				_move_active_unit(cell)
			elif (cell in _attackable_cells and Selection.atkRemaining > 0 and unitOnTile != null and unitOnTile.team != Selection.team):	#On vérifie qu'il y a une unité sur la case sélec, que l'unité qu'on a a encore des attaques à faire puis on vérifie que leurs couleurs sont différentes
				#print(Global._units)
				var casesAutourTarget : Array = _flood_fill(cell, Selection.range)
				#print(casesAutourTarget)
				if casesAutourTarget.has(Selection.tile.getCoords()) :
					#Selection.attaque(Global._units[cellI])
					GameManager.fight(Selection, unitOnTile)
					_deselect_active_unit()
					_clear_active_unit()
				else :
					
					attaqueEnAttente = true
					visuActions.clearNumbers()
					visuActions.draw_attackable_cells([cellI])	#La seule case rouge affichée est celle de l'unité(à changer quand y'aura des attaques de zone)
					attaqueEnAttenteCells = getTilesMouvementForAttaque(casesAutourTarget)
					visuActions.draw_walkable_cells(attaqueEnAttenteCells, TeamsColor.TeamsColor.EMPTY)
				
		elif(capaciteActuelle != null and MapManager.getTileAt(cellI) != null):	
			declenchementCapaActive(cellI)
	

## Selects the unit in the `cell` if there's one there.
## Sets it as the `pointeurSelec.Selection` and draws its walkable cells and interactive move path. 
func _select_unit(cell: Vector2i, ouvrirMenu : bool, typeClick : String) -> void:
	
	#print("_select_unit")
	#print(cell)
	#print(Global._units)
	var tileOn: AbstractTile = MapManager.getTileAt(cell)
	if tileOn != null && !tileOn.hasUnitOn() :
		#print(cell)
		#print(Global._units)
		#print("NON")
		if typeClick == "rightclick":		#Ouvre l'interface du joueur si il n'y a pas d'unité à cette case
			interfaceJoueurI.apercuMenusJoueur(self, true)
			
	else :
		if tileOn != null && tileOn.hasUnitOn() :
			Selection = tileOn.unitOn
			Selection.selectionneSelf(self, ouvrirMenu)
			interfaceJoueurI.apercuMenusJoueur(self, false)
			## Acquire the walkable and attackable cells
			_walkable_cells = get_walkable_cells(Selection)
			_attackable_cells = get_attackable_cells(Selection)
		
		## Draw out the walkable and attackable cells now
		if(!menuOpen && Selection != null):
			if(Selection.atkRemaining > 0) :
				visuActions.draw_attackable_cells(_attackable_cells)
			visuActions.draw_walkable_cells(_walkable_cells, Selection.team)
		#var keysWalkableCells = _walkable_cells.keys()
			_unit_path.initialize(_walkable_cells)
		
	

## Returns `true` if the cell is occupied by a unit.
func is_occupied(cell: Vector2i) -> bool:
	return MapManager.getTileAt(cell) != null and MapManager.getTileAt(cell).hasUnitOn()

## Updates the _units dictionary with the target position for the unit and asks the _active_unit to walk to it.
func _move_active_unit(new_cell: Vector2i) -> void:
	
	var keysWalkableCells = _walkable_cells.keys()
	var keyAttaqueEnAttenteCells = attaqueEnAttenteCells.keys()
	if is_occupied(new_cell) or (not new_cell in keysWalkableCells and !attaqueEnAttente) or (not new_cell in keyAttaqueEnAttenteCells and attaqueEnAttente):	#Check si le mouvement ne doit pas se dérouler
		return
	# warning-ignore:return_value_discarded
	Selection.walk_along(_unit_path.current_path)
	Selection.deplacement(MapManager.getTileAt(new_cell))
	
	#On réduit la vitesse restante pour le tour pour l'unité qui se déplace
	Selection.speedRemaining -= _walkable_cells[new_cell]
	print("finTT")
	if attaqueEnAttente :
		await Selection.signalFinMouvement
		visuActions.clearNumbers()
		visuZoneCapa.clearNumbers()
		_attackable_cells = [target.tile.getCoords()]
		attaqueEnAttenteCells = {}	#We don't need to keep them visibles after moving
		visuActions.draw_attackable_cells(_attackable_cells)
		visuActions.draw_walkable_cells(attaqueEnAttenteCells, Selection.team)
		attaqueEnAttente = false

	else :
		_deselect_active_unit()
		await Selection.signalFinMouvement
		_clear_active_unit()
	

## Deselects the active unit, clearing the cells overlay and interactive path drawing. But keep the active unit to get infos if needed before _clear_active_unit
func _deselect_active_unit() -> void:
	#print("deselect")
	
	Selection.deselectionneSelf(self)
	visuActions.clearNumbers()
	visuZoneCapa.clearNumbers()
	_unit_path.stop()
	caseTarget.visible = false
	


## Clears the reference to the pointeurSelec.Selection and the corresponding walkable cells.
func _clear_active_unit() -> void:
	interfaceJoueurI.apercuMenusJoueur(self, false)	#On efface l'aperçu du menu du joueur
	#print("_clear_active_unit()")
	menuOpen = false	#On retire le fait qu'un menu est ouvert
	Selection = null
	capaciteActuelle = null	#On verra plus tard si ça pose pas de problème
	attaqueEnAttente = false
	attaqueEnAttenteCells = {}
	_walkable_cells.clear()
	_attackable_cells.clear()




#Attributs : case <=> case de l'unité ; 
func capaActives(capaciteActivee : AbstractCapacity, uniteAssociee : AbstractUnit) -> void:
	_walkable_cells.clear()
	visuActions.clearNumbers()
	visuZoneCapa.clearNumbers()
	
	capaciteActuelle = capaciteActivee
	var allTargets = capaciteActuelle.getTargetableCells(uniteAssociee.tile)
	
	actionCells = []
	for case in allTargets:
		var tile: AbstractTile = MapManager.getTileAt(case)
		if tile != null:
			var targets: Array = []
			if tile.hasUnitOn():
				targets.append(tile.unitOn)
			if capaciteActuelle.conditionActivation(tile, targets):
				actionCells.append(case)
				
	# draw via visuActions as requested by user
	visuActions.draw_attackable_cells(actionCells)


func declenchementCapaActive(case : Vector2i) -> void :
	if !(case in actionCells):
		return
		
	var tile: AbstractTile = MapManager.getTileAt(case)
	if tile == null:
		return
		
	var targets: Array = []
	if tile.hasUnitOn():
		targets.append(tile.unitOn)
		
	if capaciteActuelle.conditionActivation(tile, targets):
		print("DECLENCHEMENT CAPACITE : " + capaciteActuelle.nameCapacity)
		capaciteActuelle.onActivation(tile, targets)
		
		# Update uses and cooldown
		if capaciteActuelle.usesRemaining > 0:
			capaciteActuelle.usesRemaining -= 1
		capaciteActuelle.currentCooldown = capaciteActuelle.cooldown
		
		# Reset unit state
		_deselect_active_unit()
		_clear_active_unit()
	else:
		print("Condition d'activation non remplie")

##Permet d'obtenir les cases où l'unité doit se déplacer pour pouvoir attaquer
func getTilesMouvementForAttaque(casesAutourTarget : Array) -> Dictionary:
	var casesPossibles : Dictionary = {}
	var set_dict = {}
	for vec in casesAutourTarget:
		set_dict[vec] = true
	for vec in _walkable_cells:
		if vec in set_dict:
			casesPossibles[vec] = _walkable_cells[vec]
	return casesPossibles

func get_placeables_cells() -> Array[Vector2i] :
	return visuPlacement.getCells()

func draw_placeable_cells(cells: Array[Vector2i]) -> void:
	visuPlacement.draw_placeable_cells(cells)

##If cell == (-1, -1), function will clear all cells hovewer it will clear only a cell
func clear_placeable_cells(cell: Vector2i = Vector2i(-1, -1)) -> void :
	if cell == Vector2i(-1, -1) :
		visuPlacement.clear()
	else :
		visuPlacement.clearTile(cell)
