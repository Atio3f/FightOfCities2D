extends AbstractUnit
class_name SniperMonkey

const STATS: UnitStats = preload("res://Ressources/units/monkeys/SniperMonkey.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	if CapacityDb.CAPACITIES.has("set1:PreciseShotCapacity"):
		var capacity = CapacityDb.CAPACITIES["set1:PreciseShotCapacity"].new(unit)
		unit.addCapacity(capacity)
