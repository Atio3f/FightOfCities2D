extends AbstractReward
class_name MagicalBeastReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {"set1:BlueMushroom": Rarities.UNIT_COMMON, "set1:TemporalSnail": Rarities.UNIT_LEGENDARY}
	initWeight()
