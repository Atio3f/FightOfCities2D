class_name LimitBreaker
extends AbstractTrinket

# All your units: increases minimum damage per attack to 4 (+3 per additional copy)
# TODO (pê) marche pas sur les unités déjà posées si on obtient le trinket en plein milieu du combat, c'est pas censé arriver pour l'instant mais on sait jamais dans le futur
const idItem = "set1:LimitBreaker"
const img = "res://assets/sprites/trinkets/PunchingBallMonkey"
const MIN_DAMAGE = 4
const MIN_DAMAGE_INCREASE = 3 # Increased min damage for each copy of this trinket (e.g. 2 Limit Breaker = 4+3=7 min damage)

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_COMMON, playerAssociated, MIN_DAMAGE, MIN_DAMAGE_INCREASE)

func onGain() -> void:
	for unit in playerAssociated.units:
		if unit != null and not unit.isDead:
			_apply_effect_to_unit(unit)

func onUnitPlace(unit: AbstractUnit) -> void:
	if unit != null and unit.player == playerAssociated and not unit.isDead:
		_apply_effect_to_unit(unit)

func _apply_effect_to_unit(unit: AbstractUnit) -> void:
	var effect: LimitBreakerEffect = LimitBreakerEffect.new(unit, -1, value_A, value_B)
	unit.addEffect(effect)
