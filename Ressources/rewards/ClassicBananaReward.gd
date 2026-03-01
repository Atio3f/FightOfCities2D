extends AbstractReward
class_name ClassicBananaReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {"set1:Banana": Rarities.ITEM_COMMON, "set1:BananaPeel": Rarities.ITEM_COMMON}
	initWeight()
