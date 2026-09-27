extends AbstractTile
class_name FortressTile

const idTile: String = "set1:FortressTile"
const walkSpeed: int = 2
const flySpeed: int = 2
const swimSpeed: int = 999

const DR_GAIN: int = 2 # DR Gain while on tile
const HEAL_AMT: int = 5 # Heal value at the start of turn

func _init(_x: int, _y: int):
	self.x = _x
	self.y = _y
	super._init(idTile, walkSpeed, flySpeed, swimSpeed)

func onUnitIn(unit: AbstractUnit) -> void :
	unit.dr += DR_GAIN

## Heal unit at start of turn
func onStartOfTurn(_unit: AbstractUnit) -> void:
	var heal: int = unitOn.onHealed(null, HEAL_AMT)
	unitOn.healHp(heal)

func onUnitOut() -> void :
	unitOn.dr -= DR_GAIN
