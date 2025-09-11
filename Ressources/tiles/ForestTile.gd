extends AbstractTile
class_name ForestTile

const idTile: String = "test:ForestTile"
const walkSpeed: int = 3
const flySpeed: int = 2
const swimSpeed: int = 999


func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
