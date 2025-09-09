extends AbstractTile
class_name MountainTile

const idTile: String = "test:MountainTile"
const walkSpeed: int = 9
const flySpeed: int = 3
const swimSpeed: int = 999


func _init(x: int, y: int):
	self.x = x
	self.y = y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
