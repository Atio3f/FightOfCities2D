extends AbstractReward
class_name BasicEquipmentsReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {
		## COMMON
		"set1:LaserBladeMonkey": Rarities.EQUIP_COMMON, "set1:CoolCapMonkey": Rarities.EQUIP_COMMON, 
		"set1:MoonStone": Rarities.EQUIP_COMMON, "set1:MudCharm": Rarities.EQUIP_COMMON,
		"set1:WarAxe": Rarities.EQUIP_COMMON, "set1:HarpyBardiche": Rarities.EQUIP_COMMON,
		## UNCOMMON
		"set1:SwagBananaBag": Rarities.EQUIP_UNCOMMON, "set1:DemonAxe": Rarities.EQUIP_UNCOMMON,
		## RARE
		"set1:WoodlandDoll": Rarities.EQUIP_RARE, "set1:BouquetOfLies": Rarities.EQUIP_RARE,
		"set1:ForceMonkeySweater": Rarities.EQUIP_RARE,
	}
	initWeight()
