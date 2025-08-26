## Draws the unit's movement path using an autotile.
class_name UnitPath
extends TileMapLayer

#@export var grid: Resource

var pathfinder: PathFinder
var current_path := PackedVector2Array()


## Creates a new PathFinder that uses the AStar algorithm to find a path between two cells among
## the `walkable_cells`.
func initialize(walkable_cells: Dictionary) -> void:
	pathfinder = PathFinder.new(walkable_cells.keys())


## Finds and draws the path between `cell_start` and `cell_end`
#cell_start and cell_end are coords Vector2i from the tilemap
func draw(cell_start: Vector2i, cell_end: Vector2i) -> void:
	current_path = pathfinder.calculate_point_path(cell_start, cell_end)
	set_cells_terrain_connect(current_path, 0, 0)


## Stops drawing, clearing the drawn path and the `_pathfinder`.
func stop() -> void:
	pathfinder = null
	clear()
