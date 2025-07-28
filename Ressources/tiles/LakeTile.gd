extends AbstractTile
class_name LakeTile

const idTile: String = "test:LakeTile"
const walkSpeed: int = 6
const flySpeed: int = 2
const swimSpeed: int = 1


func _init(x: int, y: int):
	self.x = x
	self.y = y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
