extends AbstractTile
class_name DeepWaterTile

const idTile: String = "set1:DeepWaterTile"
const walkSpeed: int = 999
const flySpeed: int = 2
const swimSpeed: int = 2


func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
