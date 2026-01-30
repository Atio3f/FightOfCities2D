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
	#astarGrid.cellSize = Vector2i(Global.cellSize, Global.cellSize)		#Taille des cases
	#astarGrid.update()
	#astarGrid.set_point_weight_scale(Vector2i(0, 0), 1)
	#astarGrid.set_point_weight_scale(Vector2i(0, 1), 2)
	#astarGrid.set_point_weight_scale(Vector2i(1, 0), 9)
	#astarGrid.set_point_weight_scale(Vector2i(1, 1), 6)

## Clear all tiles display

func resetTerrain() -> void :
	self.clear()
## Place a tile
func setTile(x: int, y: int, idTile: Vector2i) -> void :
	#Check si y'avait déjà une case avant
	
	#Placer la case en fonction des valeurs mises
	terrain.set_cell(Vector2i(x, y), 0, idTile)
	#%ShadowLayer.set_cell(Vector2i(x, y), 1, Vector2i(2, 0)) # TODO Faire en sorte qu'on le voit (pê en réduisant encore la taille des cases de base)
	

#Depuis un certain point donné(emplacement) montre les chemins disponibles avec la vitesse restante ça va pas renvoyer un void
#func deplacement_possible(emplacement : Vector2i, vitesseR : int) -> void:
	#pass




## Récupère la tuile à l'emplacement rentré en paramètre
func get_tile_data_at(emplacement : Vector2i):
	var local_position : Vector2i = terrain.local_to_map(emplacement)			#On récupère l'information de la tuile où se trouve le pointeur de souris
	return terrain.get_cell_tile_data(local_position)
