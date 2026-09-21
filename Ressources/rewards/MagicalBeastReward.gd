extends AbstractReward
class_name MagicalBeastReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {
		## COMMON
		"set1:BlueMushroom": Rarities.UNIT_COMMON, "set1:UnyieldingBear": Rarities.UNIT_COMMON,
		"set1:Fripouille": Rarities.UNIT_COMMON,
		## UNCOMMON
		"set1:Banâne": Rarities.UNIT_UNCOMMON, 
		## RARE
		"set1:CADO": Rarities.UNIT_RARE, 
		## LEGENDARY
		#"set1:TemporalSnail": Rarities.UNIT_LEGENDARY,
		"set1:StarvingShadow": Rarities.UNIT_LEGENDARY, "set1:AtlasLion": Rarities.UNIT_LEGENDARY,
		}
	initWeight()
