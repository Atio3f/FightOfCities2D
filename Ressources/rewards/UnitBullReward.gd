extends AbstractReward
class_name UnitBullReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {
		"set1:Bull": Rarities.UNIT_COMMON,
		"set1:WingedBull": Rarities.UNIT_UNCOMMON,
		"set1:BerserkerBull": Rarities.UNIT_RARE,
	}
	initWeight()
