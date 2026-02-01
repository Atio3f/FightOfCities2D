## Finds the path between two points among walkable cells using the AStar pathfinding algorithm.
class_name PathFinder
extends Resource

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

var _astar := AStarGrid2D.new()


## Initializes the AstarGrid2D object upon creation.
func _init(walkable_cells: Array) -> void:
	_astar.region = Rect2i(0, 0, MapManager.length, MapManager.width)
	_astar.cell_size = Vector2i(MapManager.cellSize, MapManager.cellSize)
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.update()
	# Iterate over all points on the grid and disable any which are
	#	not in the given array of walkable cells
	for x in range(MapManager.length):
		for y in range(MapManager.width):
			if not walkable_cells.has(Vector2i(x,y)):
				_astar.set_point_solid(Vector2i(x,y))

## Returns the path found between `start` and `end` as an array of Vector2 coordinates.
func calculate_point_path(start: Vector2i, end: Vector2i) -> PackedVector2Array:
	# With an AStarGrid2D, we only need to call get_id_path to return
	#	the expected array
	if _astar.is_in_bounds(start.x, start.y) && _astar.is_in_bounds(end.x, end.y) :
		return _astar.get_id_path(start, end) 
	else:
		return []
