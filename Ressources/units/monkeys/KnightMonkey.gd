extends AbstractUnit
class_name KnightMonkey

const STATS: UnitStats = preload("res://Ressources/units/monkeys/KnightMonkey.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	var effect1: AbstractEffect = KnightMonkeyEffect.new(unit, -1, 3)
	unit.effects.append(effect1)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
