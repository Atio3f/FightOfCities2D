extends AbstractReward
class_name UnitMonkeyReward


func _init() -> void:
	rewardsAvailable = {"set1:KnightMonkey": Rarities.raritiesUnits.COMMON, "set1:AbominationMonkey": Rarities.raritiesTrinkets.COMMON, "set1:QueenMonkey": Rarities.raritiesUnits.COMMON, "set1:GodMonkey": Rarities.raritiesUnits.COMMON}
	initWeight()
