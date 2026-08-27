extends AbstractReward
class_name TrinketBossReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {
		"set1:OrbCrate": Rarities.TRINKET_COMMON, "set1:ArtOfWar": Rarities.TRINKET_COMMON, "set1:MonkeySoap": Rarities.TRINKET_COMMON, 
		"set1:FairyBenediction": Rarities.TRINKET_COMMON, "set1:WarBanner": Rarities.TRINKET_COMMON, "set1:HRDiploma": Rarities.TRINKET_COMMON, 
		"set1:PunchingBallMonkey": Rarities.TRINKET_UNCOMMON, "set1:BananaRecipes": Rarities.TRINKET_UNCOMMON, 
		}
	initWeight()
