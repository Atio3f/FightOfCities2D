extends Node2D

var aSelectionne : bool = false 
var Selection : Node2D		#Contiendra l'unité sélectionné

var positionSouris : Vector2

@onready var caseSelec = $"../../Map/CaseSelec"
@onready var position_cam = $"../Movement"
@onready var terrain = $"../../Map/Terrain"
@onready var scene = $"../.."			#On récupère la scène pour pouvoir plus tard récup les coord du curseur de la souris

var test : TileData

#func _process(delta) -> void:
	#caseSelec.position = get_viewport().get_mouse_position()
	#print(caseSelec.position)
	#pass

func _input(event) -> void:
	if event is InputEventMouseMotion:
		positionSouris = scene.get_global_mouse_position()			#On récupère la position de la souris
		smoothyPosition()#Fonction qui centre les coords du curseur au centre d'une case
		caseSelec.position = positionSouris 						#On place caseSelec sur la case où se trouve la souris
		#print(positionSouris)
		
		test = get_tile_data_at(positionSouris)				#Marche beaucoup mieux
		#if(test) :
			#print(test.get_custom_data("vitesseRequise"))
			#
	if aSelectionne : 
		pass
	else : 
		if event is InputEventMouseButton :
			pass

func smoothyPosition() -> void:	#Permet de centrer les coords du curseur au centre d'une case
	positionSouris = Vector2i(positionSouris) / 32 * 32			#On met les coords de la souris dans un nouveau vecteur2i qui prend que
																	# des entiers(int) puis on divise par 32  avant de remultiplier par 32
																	# pour retirer le reste pour se retrouver en bas à gauche de la case 
																	#correspondante
	positionSouris = Vector2i(positionSouris.x + 16, positionSouris.y + 16)#On ajoute 16 à x et y pour se retrouver au centre de la case(ou 8 si on était sur du 16x16)

#Récupère la tuile à l'emplacement rentré en paramètre
func get_tile_data_at(emplacement : Vector2i):
	var local_position : Vector2i = terrain.local_to_map(positionSouris)			#On récupère l'information de la tuile où se trouve le pointeur de souris
	return terrain.get_cell_tile_data(0, local_position)

func get_positionSouris() -> Vector2:
	return positionSouris
