extends AbstractReward
class_name BasicItemsReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {
		## COMMON
		"set1:Banana": Rarities.ITEM_COMMON, "set1:BananaPeel": Rarities.ITEM_COMMON,
		"set1:IcyBreeze": Rarities.ITEM_COMMON, "set1:TemptationPoison": Rarities.ITEM_COMMON,
		"set1:VitalLink": Rarities.ITEM_COMMON,
		## UNCOMMON
		"set1:AssaultDroneMonkeyDeployment": Rarities.ITEM_UNCOMMON,
		## RARE
		"set1:FairyMiracle": Rarities.ITEM_RARE
	}
	initWeight()
