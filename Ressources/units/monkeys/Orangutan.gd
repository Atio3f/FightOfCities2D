extends AbstractUnit
class_name Orangutan

const STATS: UnitStats = preload("res://Ressources/units/monkeys/Orangutan.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	var effect1: AbstractEffect = OrangutanEffect.new(unit, -1, 1) # Gain a banana peel when he consume a banana 
	unit.effects.append(effect1)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
