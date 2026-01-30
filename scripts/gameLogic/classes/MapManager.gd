extends Node2D
class_name MapManager


static var tiles: Array = []	#All tiles stocked
static var activeTiles: Dictionary = {}	#Tiles actually on the visible map
static var length: int	#x
static var width: int	#y
#clé nom case, valeur =  poids de la case
const genMapDefault = {"set1:ForestTile": 100, "set1:PlainTile": 83, "set1:SwampTile": 11, "set1:LakeTile": 25, "set1:DesertTile": 5, "set1:MountainTile": 19, "set1:SakuraForestTile": 7, "set1:DeepWaterTile": 2, "set1:TropicalForestTile": 2}
#J'ai pas encore fait les autres cases
const genMapTEST = {"set1:ForestTile": 100, "set1:LakeTile": 25}
static var sceneTerrain: PackedScene = preload("res://nodes/tilemaps/terrain512x512.tscn")
static var instanceTerrain
static var terrain : Terrain	#We get the script
static var mapManager: MapManager

var visuActions: UnitOverlay
var _unit_path: UnitPath

func _ready():
	visuActions = $visualisationActions
	_unit_path = $UnitPath
	print("CREATION TERRAIN")
	createTerrain()
	

func createTerrain() -> void :
	#We instantiate here to avoid null values
	if !terrain :
		instanceTerrain = sceneTerrain.instantiate()
		terrain = instanceTerrain as Terrain
	self.add_child(terrain.getNode())	#Import the tilemap on scene
	#initMap(10, 10)

## Reset Map, including all tiles on terrain 
static func resetMap() -> void :
	tiles.clear()
	activeTiles.clear()
	if terrain :
		terrain.resetTerrain()

#pê rajouter un param mapType dans le futur pour avoir différentes générations de
#map pour le moment j'en met une par défaut ici 
static func initMap(_length: int, _width: int) -> void :
	resetMap() # Reset actual map generation and all tiles to clean up terrain
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
			placeTile(tile, Vector2i(i, j))
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
			placeTile(tile, Vector2i(i, j))
			tiles.append(tile)
			#if !terrain : Terrain.synchroTerrain()
			break
	return tile

##Add tile to activeTiles & draw it on tilemap
static func placeTile(tile: AbstractTile, coords: Vector2i) -> void :
	activeTiles[coords] = tile
	var vectorTile : Vector2i = TileDb.TILES_VECTORS[tile.id]
	terrain.setTile(coords.x, coords.y, vectorTile)

##Get tile at coordinates entered(Vector2i)
static func getTileAt(coords: Vector2i) -> AbstractTile :
	return activeTiles.get(coords)


## The size of a cell in pixels.
static var cellSize := 512
static var vectCellSize := Vector2(cellSize, cellSize)

## Half of ``cellSize``
static var _half_cell_size = cellSize / 2


## Returns the position of a cell's center in pixels.
static func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cellSize + Vector2(_half_cell_size, _half_cell_size)


## Returns the coordinates of the cell on the grid given a position on the map.
static func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return (map_position / cellSize).floor()


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

static func getTileAtCoords(coords: Vector2) -> AbstractTile:
	return getTileAt(calculate_grid_coordinates(coords))


#Permet de connaître le coût de déplacement de toutes les cases du terrain
#Was on terrain before. Now use the dictionary activeTiles instead of TileMap tiles
static func get_movement_costs(movementType: MovementTypes.movementTypes):
	
	var movement_costs = []
	var movement_cost: int
	var coords: Vector2i
	for y in range(MapManager.width):
		movement_costs.append([])
		for x in range(MapManager.length):
			coords = Vector2i(x,y)
			## This requires that all tiles with a movement cost MUST be on layer 0 of the tilemap
			#var tile = get_cell_source_id(0, Vector2i(x,y))
			var tile: AbstractTile = activeTiles[coords]
			if tile != null :		#Un peu une solution bouchon pour empêcher d'avoir une erreur quand il n'y a aucune tuile posée sur une case des dimensions de la grille qu'on a mis
				if !tile.speedRequired.has(movementType) : tile.speedRequired[movementType] = 999 #In case there is no speed indicateed for this movement type
				movement_cost = tile.speedRequired[movementType] 
			#var movement_cost = movement_data.get(tile)	#Le système pour récupérer le coût de déplacement sur la case dans le tuto
				movement_costs[y].append(movement_cost)
	return movement_costs
	

static func registerMap() -> Dictionary:
	var dataTiles: Dictionary = AbstractTile.registerTiles(tiles, activeTiles)
	var turnData := {
		"tiles": dataTiles["tiles"], 
		"activeTiles": dataTiles["activeTiles"],
		"placementTiles": GameManager.getPlaceablesTiles(),
		"length": length,
		"width": width
	}
	return turnData

static func recoverMap(data: Dictionary) -> void :
	tiles = data.tiles
	#Remettre les cases du terrain
	var tile: AbstractTile
	for tileData: Dictionary in data.activeTiles :
		if (!TileDb.TILES[tileData["id"]]) : continue
		tile = TileDb.TILES[tileData["id"]].new(tileData["x"], tileData["y"])
		placeTile(tile, tile.getCoords())
	length = data.length
	width = data.width
	
	# 
	var placementTiles: Array[Vector2i] = []
	placementTiles.assign(data.placementTiles.map(func(e): return str_to_var("Vector2i" + e)))
	GameManager.drawPlaceablesTiles(placementTiles)
