## Draws placement tiles during placement turn
class_name VisualisationPlacement
extends TileMapLayer

## Fills the tilemap with the cells, giving a visual representation of the cells where the player can place units
func draw_placeable_cells(cells: Array[Vector2i]) -> void: 
	for cell in cells:
		set_cell(cell, 0, Vector2i(0,0))

##Clear a tile
func clearTile(cell: Vector2i) -> void:
	erase_cell(cell)
