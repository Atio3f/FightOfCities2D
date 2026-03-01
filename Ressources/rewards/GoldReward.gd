extends AbstractReward
class_name GoldReward

const randomnessMin: float = 0.65
const randomnessMax: float = 1.35


func setData(_additionalData: String) -> void :
	rewardsNumber = 1
	var goldAmt: int = randi_range(int(_additionalData) * randomnessMin, int(_additionalData) * randomnessMax)
	
	totalWeight = goldAmt # Pour le moment on fait ça
	rewardsAvailable = {"gold": RarityData.new("T1", goldAmt, Rarities.TYPE_GOLD, Rarities.RARITY_COLORS["COMMON"])}
	rewards = ["gold"]
