extends AbstractUnit
class_name ArcherMonkey

const STATS: UnitStats = preload("res://Ressources/units/monkeys/ArcherMonkey.tres")
const DMG_MULTIPLIER_FLYING: int = 100 ## Bonus damage multiplier against flying targets

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	var effect: AbstractEffect = CADOEffect.new(unit, -1, DMG_MULTIPLIER_FLYING)
	unit.effects.append(effect)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
