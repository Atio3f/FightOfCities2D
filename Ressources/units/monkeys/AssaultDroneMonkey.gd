extends AbstractUnit
class_name AssaultDroneMonkey

const STATS: UnitStats = preload("res://Ressources/units/monkeys/AssaultDroneMonkey.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	#unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.FLYING]
	unit.actualMovementTypes = MovementTypes.movementTypes.FLYING
