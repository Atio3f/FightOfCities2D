extends TileMap

var astarGrid = AStarGrid2D.new()
const main_layer = 0
const main_source = 0	#id tuiles comptées

func _ready() -> void:
	setupGrid()

func setupGrid() -> void:
	astarGrid.region = Rect2i(0, 0, 79, 39)
	astarGrid.cell_size = Vector2i(16, 16)		#A changer lorsqu'on changera la taille des tuiles
	astarGrid.update()
	astarGrid.set_point_weight_scale(Vector2i(0, 0), 1)
	astarGrid.set_point_weight_scale(Vector2i(0, 1), 2)
	astarGrid.set_point_weight_scale(Vector2i(1, 0), 9)
	astarGrid.set_point_weight_scale(Vector2i(1, 1), 6)


#Depuis un certain point donné(emplacement) montre les chemins disponibles avec la vitesse restante ça va pas renvoyer un void
func deplacement_possible(emplacement : Vector2i, vitesseR : int) -> void:
	pass
