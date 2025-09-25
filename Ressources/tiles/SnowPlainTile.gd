extends AbstractTile
class_name SnowPlain

const idTile: String = "set1:SnowPlainTile"
const walkSpeed: int = 2
const flySpeed: int = 2
const swimSpeed: int = 999

func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)
