## Draws a selected unit's walkable tiles.
class_name UnitOverlay
extends TileMap


@onready var map : Node2D = $".."
const number : String = "res://nodes/interface/number.tscn"
@onready var scene = $"../.."

var listeNombre : Array = []


## NOTE:
## set_cell(x,y,z,i): z indicates the ID number in unit_overlay_tileset for which tile to draw in the overlay
## to edit this ID or to add more cells, double click the unit_overlay_tileset.tres file in the explorer
## then select the tiles added to the tileset that you would like to edit

## Fills the tilemap with the cells, giving a visual representation of the cells a unit can walk.
func draw_walkable_cells(cells: Dictionary, equipeUnite : String) -> void:
	#clear()
	print(cells)
	print("--------------")
	var keyCell : Vector2i
	for cell in cells:
		#On récupère la clé de cells(-> clé = coords case; valeur associée à la clé = coût case)
		keyCell = cell
		if Global._units.has(keyCell) :
			if Global._units[keyCell].couleurEquipe == equipeUnite :
				erase_cell(0, keyCell)
			else:
				set_cell(0, keyCell, 3, Vector2i(0,0))
			
				
		else:
			set_cell(0, keyCell, 2, Vector2i(0,0))
			var test = preload(number).instantiate()
			test.position = Vector2.ZERO
			self.add_child(test)
			test.creation(keyCell, cells[cell])
			
			

## Fills the tilemap with the cells, giving a visual representation of the cells a unit can attack
func draw_attackable_cells(cells: Array) -> void:
	for cell in cells:
		set_cell(0, cell, 3, Vector2i(0,0))
		

#Permet de retirer les nombres affichant les coûts de déplacement(2) et l'aperçu des cases d'attaque et de déplacement(1) 
func clearNumbers() -> void :
	self.clear()						#1
	for number in self.get_children():	#2
		self.remove_child(number)		#2
