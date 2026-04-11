extends AbstractUnit
class_name Banâne

const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/Banâne.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	## 2 abilities, onObtain one unit gain 2V permanently (like a permanently upgrade but w/out cost) and a second ability that can be activate on corresponding action menu to give an unit a bonus attack this turn with a 6 turns cooldown
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK

static func onObtained(unitData: StoredUnit, player: AbstractPlayer) -> void:
	# and a second ability that can be activate on corresponding action menu to give an unit a bonus attack this turn with a 6 turns cooldown
	var units: Array[StoredUnit] = player.getUnitCards()
	if units.size() > 0:
		var random_unit = units.pick_random()
		random_unit.addPermanentUpgrade("UpgradeBanâneEffect")
		print("UpgradeBanâneEffect given to random unit:", random_unit.id)
