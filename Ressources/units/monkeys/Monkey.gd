extends AbstractUnit
class_name Monkey

const STATS: UnitStats = preload("res://Ressources/units/monkeys/Monkey.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	var effect1: AbstractEffect = MonkeyEffect.new(unit, -1, 3, 1)
	unit.addEffect(effect1)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
