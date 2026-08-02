## BouquetOfLiesEffect: converts final damage into poison amount (value_A % of final damage). 
## After that, ricochet up to value_B times on enemies at 2 tiles or less to apply a poison amount equal to (value_C % of final damage).
## Unit take counter % of its own max hp as counter damage
extends AbstractEffect
class_name BouquetOfLiesEffect

const idEffect = "set1:BouquetOfLiesEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)

func onDamageDealedAfterReduction(unitTarget: AbstractUnit, damage: int, _damageType: DamageTypes.DamageTypes, visualisation: bool) -> int:
	if value_A > 0:
		if !visualisation and unitTarget != null and damage > 0:
			var poisonAmount: int = int(round(damage * (value_A / 100.0)))
			if poisonAmount > 0:
				unitTarget.addEffect(PoisonEffect.new(unitTarget, -1, poisonAmount))
				
			# Ricochet poison to other units
			var ricochetPoisonAmount: int = int(round(damage * (value_C / 100.0)))
			if ricochetPoisonAmount > 0 and value_B > 0:
				var potentialTargets: Array[AbstractUnit] = GameManager.getUnitsInRange(unitTarget.tile, 1, 2, [unitAssociated.player.team])
				potentialTargets.shuffle()
				for i in range(min(value_B, potentialTargets.size())):
					var target: AbstractUnit = potentialTargets[i]
					var effect: PoisonEffect = PoisonEffect.new(target, -1, ricochetPoisonAmount)
					target.addEffect(effect)
			# Deal self damage equal to counter % to max hp
			var selfDamageAmt: int = int(round(unitAssociated.hpMax * (counter / 100.0)))
			if selfDamageAmt > 0 :
				unitAssociated.loseHp(selfDamageAmt)
		return 0
	return damage
