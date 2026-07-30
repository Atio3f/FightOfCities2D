extends AbstractReward
class_name BasicEquipmentsReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {
		## COMMON
		"set1:LaserBladeMonkey": Rarities.EQUIP_COMMON, "set1:CoolCapMonkey": Rarities.EQUIP_COMMON, 
		"set1:MoonStone": Rarities.EQUIP_COMMON, "set1:MudCharm": Rarities.EQUIP_COMMON,
		## UNCOMMON
		"set1:SwagBananaBag": Rarities.EQUIP_UNCOMMON
	}
	initWeight()
