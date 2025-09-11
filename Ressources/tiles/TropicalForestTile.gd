extends AbstractTile
class_name TropicalForestTile

const idTile: String = "test:TropicalForestTile"
const walkSpeed: int = 5
const flySpeed: int = 2
const swimSpeed: int = 999


func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
