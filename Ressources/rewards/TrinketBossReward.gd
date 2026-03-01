extends AbstractReward
class_name TrinketBossReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {"set1:OrbCrate": Rarities.TRINKET_COMMON, "set1:ArtOfWar": Rarities.TRINKET_COMMON, "set1:MonkeySoap": Rarities.TRINKET_COMMON, "set1:PunchingBallMonkey": Rarities.TRINKET_UNCOMMON}
	initWeight()
