class_name ScorpioPalm 
extends AbstractTrinket

# All Monkeys gain 2 DR
# Toutes vos unités maitrisent désormais la technique martiale de la paume du scorpion
const idItem = "set1:ScorpioPalm"
const img = "res://assets/sprites/trinkets/MonkeySoap"
const PARALYSIS_AMT = 1 # Apply one paralysis on melee attacks

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_RARE, playerAssociated, PARALYSIS_AMT)

func onGain() -> void:
	# Should not activate since we gain Trinkets outside fights in general (maybe some enemies will allow this ?)
	for unit in playerAssociated.units:
		var effect: OnHitApplyStatusEffect = OnHitApplyStatusEffect.new(unit, -1, value_A, 1, 0)
		unit.addEffect(effect)

func onUnitPlace(unit: AbstractUnit) -> void:
	if unit.player == playerAssociated:
		var effect: OnHitApplyStatusEffect = OnHitApplyStatusEffect.new(unit, -1, value_A, 1, 0)
		unit.addEffect(effect)
