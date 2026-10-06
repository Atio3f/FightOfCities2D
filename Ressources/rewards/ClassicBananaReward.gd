extends AbstractReward
class_name ClassicBananaReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {
		"set1:Banana": Rarities.ITEM_COMMON, "set1:BananaPeel": Rarities.ITEM_COMMON,
		"set1:MashedBananas": Rarities.BONUS_UNCOMMON, "set1:ChargedBananaJuice": Rarities.BONUS_UNCOMMON,
		"set1:BananaCake": Rarities.BONUS_RARE, "set1:ElectricBanana": Rarities.BONUS_RARE, 
		}
	initWeight()
