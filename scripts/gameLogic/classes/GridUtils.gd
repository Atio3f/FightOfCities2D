## Utility class to handle grid calculations, like unit pathing and attack range finding
class_name GridUtils
extends RefCounted

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
const MAX_VALUE: int = 99999

## Helper function to find paths for movements
static func get_walkable_cells(unit: AbstractUnit) -> Dictionary:
	var tileOnCoords: Vector2i = unit.tile.getCoords()
	## Add adjacents tiles if the unit can't move and have full speed because its max speed is inferior to adjacent tiles 
	if unit.speed == unit.speedRemaining :
		var cells: Dictionary = dijkstra(tileOnCoords, unit.speedRemaining, false, unit.actualMovementTypes, unit)
		#print(cells)
		for direction in DIRECTIONS:
			var coords: Vector2i = tileOnCoords + direction
			if !cells.has(coords) && MapManager.getTileAt(coords) != null && !(MapManager.getTileAt(coords).hasUnitOn()):
				cells[coords] = unit.speed
		
		return cells
	else :
		return dijkstra(tileOnCoords, unit.speedRemaining, false, unit.actualMovementTypes, unit)

## Helper function to find paths for attacks and movements
static func get_attackable_cells(unit: AbstractUnit) -> Array[Vector2i]:
	var attackable_cells : Array[Vector2i] = []
	var real_walkable_cells = get_walkable_cells(unit)
	
	## Iterate through every single cell and find their partners based on attack range(stat range)
	for curr_cell in real_walkable_cells:
		for curr_range in range(1, unit.range + 1):
			for cell: Vector2i in flood_fill(curr_cell, unit.range):
				if !attackable_cells.has(cell) : attackable_cells.append(cell)	#Avoid doblons
	
	return attackable_cells.filter(func(i): return i not in real_walkable_cells)

## Helper function to find paths for attacks, track all cells in range of the unit to attack
static func flood_fill(cell: Vector2i, max_distance: int) -> Array[Vector2i]:
	var full_array : Array[Vector2i] = []	
	var stack := [cell]
	while not stack.size() == 0:
		var current = stack.pop_back()
		if not MapManager.is_within_bounds(current):
			continue
		if current in full_array:
			continue

		var difference: Vector2i = (current - cell).abs()
		var distance := int(difference.x + difference.y)
		if distance > max_distance:
			continue

		full_array.append(current)
		for direction in DIRECTIONS:
			var coordinates: Vector2i = current + direction
			
			## This detects the impassable objects we define in the TileSet based on the Atlas ID
			## If you don't want units to attack over walls and only around them comment out this line and put 'continue'
			#if map.get_cell_source_id(0, coordinates) == OBSTACLE_ATLAS_ID:
				#wall_array.append(coordinates)
				#continue
			
			#if is_occupied(coordinates):
			#	continue
			if coordinates in full_array:
				continue
			# Minor optimization: If this neighbor is already queued
			#	to be checked, we don't need to queue it again
			if coordinates in stack:
				continue
			
			stack.append(coordinates)
	# Filter out all the walls and return attackable cells 
	return full_array # Was full_array.filter(func(i): return i not in wall_array) 

## Helper function to find paths for movements and attacks
static func dijkstra(cell: Vector2i, max_distance: int, attackable_check: bool, movementType : MovementTypes.movementTypes, unit: AbstractUnit = null) -> Dictionary:
	var curr_unit = unit
	# moveable_cells est maintenant un dictionnaire avec comme clé les coords d'une case et en valeur le coût de déplacement vers cette case
	var movable_cells = {cell : 0} # Cellule où se trouve l'unité a un coût de 0 du coup
	var visited = [] # 2d array that keeps track of which cells we've already looked at while running the algorithm
	var distances = [] # shows distance to each cell, might be useful. can omit if you want to
	var previous = [] #2d array that shows you which cell you have to take to get there to get the shortest path. can omit if you want to
	# the previous array can be used to recontruct the path alogrithm found to the previous node you were at
	## Refresh the cost of each tile to get the true values based on the movement type of unit

	var _movement_costs = MapManager.get_movement_costs(movementType)
	
	## iterate over width and height of the grid
	for y in range(MapManager.width):
		visited.append([])
		distances.append([])
		previous.append([])
		for x in range(MapManager.length):
			visited[y].append(false)
			distances[y].append(MAX_VALUE)
			previous[y].append(null)
	
	## Make new Priority Queue (min heap) to store cells to visit, ordered by distance
	var queue = PriorityQueue.new()
	queue.push(cell, 0) 
	distances[cell.y][cell.x] = 0
	
	var tile_cost
	var distance_to_node
	var occupied_cells = []
	 
	## While there is still a node in the queue, we'll keep looping
	while not queue.is_empty():
		var current = queue.pop() 
		visited[current.value.y][current.value.x] = true # mark front node as marqued
		
		for direction in  DIRECTIONS:
			var coordinates = current.value + direction #Go through all four neighbors of current node
			var coordinatesI : Vector2i = coordinates	
			if MapManager.is_within_bounds(coordinates):
				if visited[coordinates.y][coordinates.x]:
					continue
				else:
					if ( _movement_costs[coordinates.y].size() > coordinates.x ):	#Vérification que la case a une tuile
						tile_cost = _movement_costs[coordinates.y][coordinates.x]
					
						if movementType == MovementTypes.movementTypes.FLYING:
							distance_to_node = current.priority + 2 
						else :
							distance_to_node = current.priority + tile_cost 
					
						## Check to see if tile is occupied by opposite team or is waiting
						## the "or _units[coordinates].is_wait" is the line that you will use to calculate 
						## Actual attack range for display on hover/walkvar is_occupied = MapManager.getTileAt(coordinatesI) != null and MapManager.getTileAt(coordinatesI).hasUnitOn()
						if is_occupied(coordinatesI):
							var unitI: AbstractUnit = MapManager.getTileAt(coordinatesI).unitOn
							if curr_unit != null && curr_unit.team != unitI.team: 
								distance_to_node = current.priority + MAX_VALUE 
							## Remove this if you want attack ranges to be seen past units that are waiting METTRE elif si le if du dessus est décommentée
							elif unitI.is_wait and attackable_check:
								occupied_cells.append(coordinates)
						
						visited[coordinates.y][coordinates.x] = true
						distances[coordinates.y][coordinates.x] = distance_to_node
					else :
						distance_to_node = null
						
				if distance_to_node != null and distance_to_node <= max_distance and !occupied_cells.has(coordinatesI): 
					previous[coordinates.y][coordinates.x] = current.value 
					movable_cells[coordinates] = distance_to_node 
					queue.push(coordinates, distance_to_node) 
	
	return movable_cells

## Returns `true` if the cell is occupied by a unit.
static func is_occupied(cell: Vector2i) -> bool:
	return MapManager.getTileAt(cell) != null and MapManager.getTileAt(cell).hasUnitOn()

## Reconstructs the shortest path from a start cell to a destination cell for an AI unit
static func find_path(unit: AbstractUnit, start: Vector2i, destination: Vector2i) -> PackedVector2Array:
	var path = PackedVector2Array()
	if start == destination:
		return path
		
	var movementType = unit.actualMovementTypes
	var visited = [] 
	var previous = [] 
	var _movement_costs = MapManager.get_movement_costs(movementType)
	
	for y in range(MapManager.width):
		visited.append([])
		previous.append([])
		for x in range(MapManager.length):
			visited[y].append(false)
			previous[y].append(null)
			
	var queue = PriorityQueue.new()
	queue.push(start, 0) 
	
	var found = false
	while not queue.is_empty():
		var current = queue.pop() 
		visited[current.value.y][current.value.x] = true 
		
		if current.value == destination:
			found = true
			break
			
		for direction in DIRECTIONS:
			var coordinates = current.value + direction 
			if MapManager.is_within_bounds(coordinates):
				if visited[coordinates.y][coordinates.x]:
					continue
					
				if _movement_costs[coordinates.y].size() > coordinates.x:	
					var tile_cost = _movement_costs[coordinates.y][coordinates.x]
					var dist = current.priority + (2 if movementType == MovementTypes.movementTypes.FLYING else tile_cost)
					
					# Allow moving to destination even if occupied (e.g. for attack range simulation)
					if is_occupied(coordinates) and coordinates != destination:
						var unitI: AbstractUnit = MapManager.getTileAt(coordinates).unitOn
						if unit.team != unitI.team: 
							continue
							
					previous[coordinates.y][coordinates.x] = current.value
					visited[coordinates.y][coordinates.x] = true
					queue.push(coordinates, dist)
					
	if found:
		var curr = destination
		var temp_path = []
		while curr != null and curr != start:
			temp_path.append(curr)
			curr = previous[curr.y][curr.x]
		temp_path.reverse()
		for pt in temp_path:
			path.append(pt)
			
	return path
