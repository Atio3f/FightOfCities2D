extends AbstractTile
class_name PlainTile

const idTile: String = "test:PlainTile"
const walkSpeed: int = 1
const flySpeed: int = 2
const swimSpeed: int = 999


func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
