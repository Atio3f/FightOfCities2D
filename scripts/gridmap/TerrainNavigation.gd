extends TileMapLayer
class_name Terrain

#var astarGrid = AStarGrid2D.new()
const main_layer = 0
const main_source = 0	#id tuiles comptées

var movement_data	#Dictionnaire contenant les coûts de déplacements des tuiles
#@onready var terrain = $"../Terrain512x512"
var terrain = self

func _ready():
	## Reference variable to any particular movement cost of any particular tile
	#movement_data = tile_set.movement_data
	setupGrid()

func getNode() -> TileMapLayer:
	return $"."

func setupGrid() -> void:
	pass
	#astarGrid.region = Rect2i(0, 0, 80, 80)
	#astarGrid.cell_size = Vector2i(Global.cellSize, Global.cellSize)		#Taille des cases
	#astarGrid.update()
	#astarGrid.set_point_weight_scale(Vector2i(0, 0), 1)
	#astarGrid.set_point_weight_scale(Vector2i(0, 1), 2)
	#astarGrid.set_point_weight_scale(Vector2i(1, 0), 9)
	#astarGrid.set_point_weight_scale(Vector2i(1, 1), 6)

#Place a tile
func setTile(x: int, y: int, idTile: Vector2i) -> void :
	#Check si y'avait déjà une case avant
	
	#Placer la case en fonction des valeurs mises
	terrain.set_cell(Vector2i(x, y), 1, idTile)
	
	

#Depuis un certain point donné(emplacement) montre les chemins disponibles avec la vitesse restante ça va pas renvoyer un void
func deplacement_possible(emplacement : Vector2i, vitesseR : int) -> void:
	pass

#Permet de connaître le coût de déplacement de toutes les cases du terrain
func get_movement_costs(grid : Grid):
	
	var movement_costs = []
	for y in range(grid.size.y):
		movement_costs.append([])
		for x in range(grid.size.x):
			## This requires that all tiles with a movement cost MUST be on layer 0 of the tilemap
			#var tile = get_cell_source_id(0, Vector2i(x,y))
			var tile = terrain.get_cell_tile_data(Vector2i(x,y))
			if tile != null :		#Un peu une solution bouchon pour empêcher d'avoir une erreur quand il n'y a aucune tuile posée sur une case des dimensions de la grille qu'on a mis
				var movement_cost = tile.get_custom_data("vitesseRequise")
			#var movement_cost = movement_data.get(tile)	#Le système pour récupérer le coût de déplacement sur la case dans le tuto
				movement_costs[y].append(movement_cost)
	return movement_costs


#Récupère la tuile à l'emplacement rentré en paramètre
func get_tile_data_at(emplacement : Vector2i):
	var local_position : Vector2i = terrain.local_to_map(emplacement)			#On récupère l'information de la tuile où se trouve le pointeur de souris
	return terrain.get_cell_tile_data(local_position)
