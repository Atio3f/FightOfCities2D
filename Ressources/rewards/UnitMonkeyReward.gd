extends AbstractReward
class_name UnitMonkeyReward


func _init() -> void:
	rewardsAvailable = {"set1:KnightMonkey": Rarities.UNIT_COMMON, "set1:AbominationMonkey": Rarities.UNIT_UNCOMMON,
	 "set1:QueenMonkey": Rarities.UNIT_UNCOMMON, "set1:GodMonkey": Rarities.UNIT_RARE}
	initWeight()
