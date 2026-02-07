extends AbstractUnit
class_name GodMonkey

const STATS: UnitStats = preload("res://Ressources/units/monkeys/GodMonkey.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	var effect1: AbstractEffect = GodMonkeySpeedEffect.new(unit, -1, 1)
	var effect2: AbstractEffect = GodMonkeyHealEffect.new(unit, -1, 8)
	unit.effects.append(effect1)
	unit.effects.append(effect2)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
