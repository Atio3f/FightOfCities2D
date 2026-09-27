extends AbstractUnit
class_name HammerHeadBull

const STATS: UnitStats = preload("res://Ressources/units/bulls/HammerHeadBull.tres")
const SELF_DAMAGE: int = 4

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	var effect1: AbstractEffect = HammerHeadBullEffect.new(unit, -1, SELF_DAMAGE)
	unit.addEffect(effect1)
	var effect2: AbstractEffect = PenetrationPhysicalEffect.new(unit, -1, 80, 1)
	unit.addEffect(effect2)
