extends AbstractTile
class_name MountainTile

const idTile: String = "test:MountainTile"
const walkSpeed: int = 9
const flySpeed: int = 3
const swimSpeed: int = 999


func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
