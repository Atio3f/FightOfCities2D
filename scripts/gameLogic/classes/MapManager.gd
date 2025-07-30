extends Node
class_name MapManager


static var tiles: Array = []	#All tiles stocked
static var activeTiles: Dictionary = {}	#Tiles actually on the visible map
static var length: int
static var width: int
#clé nom case, valeur =  poids de la case
const genMapDefault = {"test:ForestTile": 100, "test:PlainTile": 83, "test:SwampTile": 11, "test:LakeTile": 25, "test:DesertTile": 5, "test:MountainTile": 19, "test:SakuraForestTile": 7, "test:DeepWaterTile": 2, "test:TropicalForestTile": 2}
#J'ai pas encore fait les autres cases
const genMapTEST = {"test:ForestTile": 100, "test:LakeTile": 25}
static var sceneTerrain: PackedScene = preload("res://nodes/tilemaps/terrain512x512.tscn")
static var instanceTerrain = sceneTerrain.instantiate()
static var terrain : Terrain = instanceTerrain as Terrain	#We get the script

func _ready():
	print("CREATION TERRAIN")
	createTerrain()

func createTerrain() -> void :
	%Map.add_child(terrain.getNode())	#Import the tilemap on scene
	initMap(10, 10)
	print("ezarz")
#pê rajouter un param mapType dans le futur pour avoir différentes générations de
#map pour le moment j'en met une par défaut ici 
static func initMap(_length: int, _width: int) -> void :
	length = _length
	width = _width
	var genMaxValue: int = 0
	for weight: int in genMapDefault.values() :
		genMaxValue += weight
	var i : int = 0
	var j : int = 0
	var tile: AbstractTile
	while i < _length :
		while j < _width :
			tile = pickTile(genMaxValue, i, j, genMapDefault)
			activeTiles[Vector2i(i, j)] = tile
			tiles.append(tile)
			
			j += 1
		i += 1
		j = 0
	

static func pickTile(totalWeight: int, i: int, j: int, genMap: Dictionary) -> AbstractTile:
	var random = randi() % totalWeight
	var current = 0
	var tile: AbstractTile
	
	for tile_name in genMap.keys():
		current += genMap[tile_name]
		if random < current:
			tile = TileDb.TILES[tile_name].new(i, j)
			var vectorTile : Vector2i = TileDb.TILES_VECTORS[tile.id]
			#if !terrain : Terrain.synchroTerrain()
			terrain.setTile(i, j, vectorTile)
			break
	return tile

static func getTileAt(coords: Vector2i) -> AbstractTile :
	return activeTiles.get(coords)

## The size of a cell in pixels.
static var cell_size := Vector2(512, 512)

## Half of ``cell_size``
static var _half_cell_size = cell_size / 2


## Returns the position of a cell's center in pixels.
static func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + _half_cell_size


## Returns the coordinates of the cell on the grid given a position on the map.
static func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return (map_position / cell_size).floor()


## Returns true if the `cell_coordinates` are within the grid.
static func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var pos := cell_coordinates.x >= 0 and cell_coordinates.x < length
	return pos and cell_coordinates.y >= 0 and cell_coordinates.y < width


## Makes the `grid_position` fit within the grid's bounds.
static func grid_clamp(grid_position: Vector2) -> Vector2:
	var pos := grid_position
	pos.x = clamp(pos.x, 0, length - 1.0)
	pos.y = clamp(pos.y, 0, width - 1.0)
	return pos


static func registerMap() -> Dictionary:
	var turnData := {
		"tiles": tiles, 
		"activeTiles": activeTiles,
		"length": length,
		"width": width
	}
	return turnData

static func recoverMap(data: Dictionary, player: AbstractPlayer) -> void :
	tiles = data.tiles
	activeTiles = data.activeTiles
	length = data.length
	width = data.width
	#Remettre les cases du terrain
	
