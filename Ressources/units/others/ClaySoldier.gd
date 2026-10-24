extends AbstractUnit
class_name ClaySoldier

const STATS: UnitStats = preload("res://Ressources/units/others/ClaySoldier.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	# 5 PV Temp à toutes vos unités au début du combat
	var effect1: AbstractEffect = ClaySoldierEffect.new(unit, -1, 5)
	unit.addEffect(effect1)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
