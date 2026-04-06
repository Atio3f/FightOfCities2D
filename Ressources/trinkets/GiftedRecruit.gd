class_name GiftedRecruit
extends AbstractTrinket

# Next recruit gain 2 randoms upgrades
# Un diplôme avec des cartes de divination pour mieux choisir ses recrues
const idItem = "set1:GiftedRecruit"
const img = "res://assets/sprites/trinkets/ArtOfWar"
const NBR_UPGRADES = 2

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_COMMON, playerAssociated, NBR_UPGRADES)

## Activate when you gain an unit
func onUnitGained(unitData: StoredUnit) -> StoredUnit :
	if counter == 1 : return unitData
	# Give 2 randoms upgrade to the unit recruited
	var reward: AbstractReward = RewardDb.REWARDS["reward:bonus"].new()
	reward.setData("")
	reward.randomizeRewards()
	for i in range(0, value_A) :
		unitData.addPermanentUpgrade(reward.rewards[i]) # Avoid to have 2 times the same upgrade, could be change if needed by replacing i by 0 and adding randomizeRewards
		print(reward.rewards[i])
	# Disable trinket
	counter = 1
	## TODO Should display that trinket is off
	return unitData
