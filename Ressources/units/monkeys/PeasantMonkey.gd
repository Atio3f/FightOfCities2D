extends AbstractUnit
class_name PeasantMonkey

const STATS: UnitStats = preload("res://Ressources/units/monkeys/PeasantMonkey.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	var effect1: AbstractEffect = PeasantMonkeyEffect.new(unit, -1, 0)
	unit.addEffect(effect1)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
