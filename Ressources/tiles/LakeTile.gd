extends AbstractTile
class_name LakeTile

const idTile: String = "set1:LakeTile"
const walkSpeed: int = 6
const flySpeed: int = 2
const swimSpeed: int = 1


func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
