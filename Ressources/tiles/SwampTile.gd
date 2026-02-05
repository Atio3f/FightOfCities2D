extends AbstractTile
class_name SwampTile

const idTile: String = "set1:SwampTile"
const walkSpeed: int = 5
const flySpeed: int = 2
const swimSpeed: int = 3
const dmgPerTurn: int = 4

func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)


func onStartOfTurn(unit: AbstractUnit) -> void:
	if unit != null && !unit.isDead: 
		unit.onDamageTaken(null, dmgPerTurn, DamageTypes.DamageTypes.UNKNOW, false)
	return
