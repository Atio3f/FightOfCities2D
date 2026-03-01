extends AbstractReward
class_name UnitMonkeyReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {"set1:KnightMonkey": Rarities.UNIT_COMMON, "set1:AbominationMonkey": Rarities.UNIT_UNCOMMON,
	 "set1:QueenMonkey": Rarities.UNIT_RARE, "set1:GodMonkey": Rarities.UNIT_LEGENDARY}
	initWeight()
