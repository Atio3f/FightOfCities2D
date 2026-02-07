extends AbstractUnit
class_name QueenMonkey

const STATS: UnitStats = preload("res://Ressources/units/monkeys/QueenMonkey.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	var effect1: AbstractEffect = QueenMonkeyEffect.new(unit, -1, 100)
	unit.effects.append(effect1)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
