extends Label

@export var grid : Resource


func creation(cell : Vector2, valeur : int) -> void:
	
	text = str(valeur)
	#print(cell)
	
	cell = MapManager.grid_clamp(cell) * MapManager.cellSize
	global_position = cell
	top_level = true
	self.set_deferred("size", Vector2(Global.cellSize, Global.cellSize)) 


func getText() -> String :
	return text
