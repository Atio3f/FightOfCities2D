extends AbstractTile
class_name TropicalForestTile

const idTile: String = "test:TropicalForestTile"
const walkSpeed: int = 5
const flySpeed: int = 2
const swimSpeed: int = 999


func _init(x: int, y: int):
	self.x = x
	self.y = y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
