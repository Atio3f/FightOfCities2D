extends AbstractTile
class_name ForestTile

const idTile: String = "test:ForestTile"
const walkSpeed: int = 3
const flySpeed: int = 2
const swimSpeed: int = 999


func _init(x: int, y: int):
	self.x = x
	self.y = y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
