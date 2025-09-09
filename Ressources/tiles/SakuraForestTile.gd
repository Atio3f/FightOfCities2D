extends AbstractTile
class_name SakuraForest

const idTile: String = "test:SakuraForestTile"
const walkSpeed: int = 1
const flySpeed: int = 2
const swimSpeed: int = 999
const healValue: int = 4

func _init(x: int, y: int):
	self.x = x
	self.y = y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)


func onStartOfTurn(unit: AbstractUnit) -> void:
	if unit != null && !unit.isDead: 
		var finalHeal: int = unit.onHeal(null, healValue)
		unit.healHp(finalHeal)
	return
