extends AbstractTile
class_name SakuraForest

const idTile: String = "set1:SakuraForestTile"
const walkSpeed: int = 1
const flySpeed: int = 2
const swimSpeed: int = 999
const healValue: int = 4

func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)


func onStartOfTurn(unit: AbstractUnit) -> void:
	if unit != null && !unit.isDead: 
		var finalHeal: int = unit.onHeal(null, healValue)
		unit.healHp(finalHeal)
	return
