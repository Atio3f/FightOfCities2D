extends AbstractTile
class_name VolcanicRocksTile

const idTile: String = "set1:VolcanicRocksTile"
const walkSpeed: int = 2
const flySpeed: int = 2
const swimSpeed: int = 999
const dmgPerTurn: int = 20

func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)


func onStartOfTurn(unit: AbstractUnit) -> void:
	if unit != null && !unit.isDead: 
		unit.onDamageTaken(null, dmgPerTurn, DamageTypes.DamageTypes.FIRE, false)
	return
