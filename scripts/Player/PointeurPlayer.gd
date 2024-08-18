extends Node2D

var aSelectionne : bool = false 
var Selection : Node2D		#Contiendra l'unité sélectionné

var positionSouris : Vector2i

@onready var caseSelec = $"../../Map/CaseSelec"
@onready var position_cam = $"../Movement"
@onready var terrain = $"../../Map/Terrain32x32"
@onready var scene = $"../.."			#On récupère la scène pour pouvoir plus tard récup les coord du curseur de la souris
@onready var map = $"../../Map"

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
var test : TileData
var cellSize : int = 32

signal accept_pressed

#func _process(delta) -> void:
	#caseSelec.position = get_viewport().get_mouse_position()
	#print(caseSelec.position)
	#pass

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
		if aSelectionne : 
			pass
		else : 
			if event.is_action_pressed("leftClick"):
				emit_signal("accept_pressed", positionSouris)

#Permet de centrer les coords du curseur au centre d'une case NE SERVIRA PROBABLEMENT PLUS
func smoothyPosition() -> void:	
	positionSouris = Vector2i(positionSouris) / 32 * 32			#On met les coords de la souris dans un nouveau vecteur2i qui prend que
																	# des entiers(int) puis on divise par 32  avant de remultiplier par 32
																	# pour retirer le reste pour se retrouver en bas à gauche de la case 
																	#correspondante
	positionSouris = Vector2i(positionSouris.x + 16, positionSouris.y + 16)#On ajoute 16 à x et y pour se retrouver au centre de la case(ou 8 si on était sur du 16x16)



## Returns an array of cells a given unit can walk using the flood fill algorithm.
func get_walkable_cells(unit: unite) -> Array:
	return _dijkstra(unit.cell, unit.V, false)

## Return an array of cells a given unit can attack using dijkstra's and flood fill algorithm
func get_attackable_cells(unit: unite) -> Array:
	var attackable_cells = []
	var real_walkable_cells = _dijkstra(unit.cell, unit.V, true)
	
	## iterate through every single cell and find their partners based on attack range(stat range)
	for curr_cell in real_walkable_cells:
		for curr_range in range(1, unit.attack_range + 1):
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
func _dijkstra(cell: Vector2, max_distance: int, attackable_check: bool) -> Array:
	var curr_unit = map._units[cell]
	var movable_cells = [cell] # append our base cell to the array
	var visited = [] # 2d array that keeps track of which cells we've already looked at while running the algorithm
	var distances = [] # shows distance to each cell, might be useful. can omit if you want to
	var previous = [] #2d array that shows you which cell you have to take to get there to get the shortest path. can omit if you want to
	## the previous array can be used to recontruct the path alogrithm found to the previous node you were at
	
	## iterate over width and height of the grid
	for y in range(map.grid.size.y):
		visited.append([])
		distances.append([])
		previous.append([])
		for x in range(map.grid.size.x):
			visited[y].append(false)
			distances[y].append(map.MAX_VALUE)
			previous[y].append(null)
	
	## Make new queue
	var queue = PriorityQueue.new()
	
	queue.push(cell, 0) #starting cell
	distances[cell.y][cell.x] = 0
	print(cell.y)
	print(cell.x)
	var tile_cost
	var distance_to_node
	var occupied_cells = []
	
	## While there is still a node in the queue, we'll keep looping
	while not queue.is_empty():
		var current = queue.pop() #take out the front node
		visited[current.value.y][current.value.x] = true #mark front node as visited
		
		for direction in  DIRECTIONS:
			var coordinates = current.value + direction #Go through all four neighbors of current node
			if map.grid.is_within_bounds(coordinates):
				if visited[coordinates.y][coordinates.x]:
					continue
				else:
					tile_cost = map._movement_costs[coordinates.y][coordinates.x]
					
					distance_to_node = current.priority + tile_cost #calculate tile cost normally
					
					## Check to see if tile is occupied by opposite team or is waiting
					## the "or _units[coordinates].is_wait" is the line that you will use to calculate 
					## Actual attack range for display on hover/walk
					if map.is_occupied(coordinates):
						if curr_unit.is_enemy != map._units[coordinates].is_enemy: #Remove this line if you want to make every unit impassable
							distance_to_node = current.priority + map.MAX_VALUE #Mark enemy tile as impassable
						## remove this if you want attack ranges to be seen past units that are waiting
						elif map._units[coordinates].is_wait and attackable_check:
							occupied_cells.append(coordinates)
					
					visited[coordinates.y][coordinates.x] = true
					distances[coordinates.y][coordinates.x] = distance_to_node
				
				if distance_to_node <= max_distance: #check if node is actually reachable by our unit
					previous[coordinates.y][coordinates.x] = current.value #mark tile we used to get here
					movable_cells.append(coordinates) #attach new node we are looking at as reachable
					queue.push(coordinates, distance_to_node) #use distance as priority
	
	return movable_cells.filter(func(i): return i not in occupied_cells)
#Récupère la tuile à l'emplacement rentré en paramètre
func get_tile_data_at(emplacement : Vector2i):
	var local_position : Vector2i = terrain.local_to_map(positionSouris)			#On récupère l'information de la tuile où se trouve le pointeur de souris
	return terrain.get_cell_tile_data(0, local_position)

func getMiddleMouseCell() -> Vector2:
	var middleMouse : Vector2 = Vector2(positionSouris.x * 32 + 16, positionSouris.y * 32 + 16)
	return middleMouse

#On fait le calcul du nouvel emplacement dans Action avec
func changementEmplacement() -> void:
	map.pointeurHasMove(positionSouris)	#On transmet le signal "moved" qui sert pour la visualisation des actions possibles
