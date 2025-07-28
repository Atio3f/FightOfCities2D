extends AbstractTile
class_name PlainTile

const idTile: String = "test:PlainTile"
const walkSpeed: int = 1
const flySpeed: int = 2
const swimSpeed: int = 999


func _init(x: int, y: int):
	self.x = x
	self.y = y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
