extends AbstractUnit
class_name UnyieldingBear

const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/UnyieldingBear.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	var effect: AbstractEffect = UnyieldingBearEffect.new(unit, -1, 2)
	unit.effects.append(effect)
