extends AbstractUnit
class_name Fripouille

# Chat Adorant Dégager les Oiseaux 
const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/Fripouille.tres")
const DURATION: int = 3
const START_BONUS_AMT: int = 5 ## Bonus stats on first 3 turns

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	var effect: AbstractEffect = DRPlusEffect.new(unit, DURATION, START_BONUS_AMT)
	unit.addEffect(effect)
	var effect2: AbstractEffect = MRPlusEffect.new(unit, DURATION, START_BONUS_AMT)
	unit.addEffect(effect2)
	var effect3: AbstractEffect = PowerPlusEffect.new(unit, DURATION, START_BONUS_AMT)
	unit.addEffect(effect3)
	var effect4: AbstractEffect = SpeedPlusEffect.new(unit, DURATION, START_BONUS_AMT)
	unit.addEffect(effect4)
