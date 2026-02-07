extends AbstractUnit
class_name AbominationMonkey

const STATS: UnitStats = preload("res://Ressources/units/monkeys/AbominationMonkey.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	var effect1: AbstractEffect = AbominationMonkeyEffect.new(unit, -1, 1, 1)
	unit.effects.append(effect1)
	var effect2: AbstractEffect = PenetrationPhysicalEffect.new(unit, -1, 100, 1)
	unit.effects.append(effect2)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
