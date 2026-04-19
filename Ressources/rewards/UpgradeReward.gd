extends AbstractReward
class_name UpgradeReward

func setData(_additionalData: String = "") -> void :
	rewardsNumber = 3 # Number choices
	
	## TODO
	# Si tu as passé des infos via _additionalData (ex: un niveau de rareté ou type de bonus à donner), 
	# tu peux t'en servir ici avec un match. Sinon, on met un pool par défaut.
	
	# On remplit le dictionnaire avec les ID de tes bonus permanents 
	# et leur RarityData
	rewardsAvailable = {
		"UpgradeAgilityEffect": Rarities.BONUS_COMMON,
		"UpgradePromotionEffect": Rarities.BONUS_COMMON,
		"UpgradeScoutEffect": Rarities.BONUS_COMMON,
		"UpgradeBloodyEffect": Rarities.BONUS_COMMON,
		"UpgradeSneakyEffect": Rarities.BONUS_UNCOMMON,
		"UpgradeHiddenPotentialEffect": Rarities.BONUS_UNCOMMON,
		"UpgradeTestEffect": Rarities.BONUS_COMMON
	}
	
	# Calc probabilities
	initWeight()
