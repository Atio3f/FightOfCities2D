extends AbstractTile
class_name DeepWaterTile

const idTile: String = "test:DeepWaterTile"
const walkSpeed: int = 999
const flySpeed: int = 2
const swimSpeed: int = 2


func _init(x: int, y: int):
	self.x = x
	self.y = y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
