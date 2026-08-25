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
		"UpgradeTestEffect": Rarities.BONUS_COMMON,
		"UpgradeScoutEffect": Rarities.BONUS_COMMON,
		"UpgradeBloodyEffect": Rarities.BONUS_COMMON,
		"UpgradeGlassCanonEffect": Rarities.BONUS_COMMON,
		"UpgradeCrossfitDudeEffect": Rarities.BONUS_COMMON,
		"UpgradeSneakyEffect": Rarities.BONUS_UNCOMMON,
		"UpgradePromotionEffect": Rarities.BONUS_UNCOMMON, # C'était commun à la base jsp faudra voir
		"UpgradeHiddenPotentialEffect": Rarities.BONUS_UNCOMMON,
		"UpgradeMultitaskingEffect": Rarities.BONUS_UNCOMMON,
		"UpgradeBloodGiftEffect": Rarities.BONUS_UNCOMMON,
	}
	
	# Calc probabilities
	initWeight()
