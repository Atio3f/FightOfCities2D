extends AbstractReward
class_name ClassicBananaReward


func _init() -> void:
	#TODO CHANGE REWARD TO GIVE BANANA ITEMS
	rewardsAvailable = {"set1:Banana": Rarities.ITEM_COMMON, "set1:BananaPeel": Rarities.ITEM_COMMON}
	initWeight()
