extends Node
class_name AbstractReward

var rewardInterface: PackedScene = preload("res://nodes/interface/metaUI/placeholderScreens/rewardChoiceInterface.tscn")
#Reward screen scene variable
var rewardsAvailable: Dictionary = {}#List of items obtainable from the reward, key is item id and value is item weight
var totalWeight: int = 0	#Total weight of all items on rewardsAvailable
var rewards: Array[String] = []	#Rewards list for the returned screen reward
var rewardsNumber: int = 3	#Number of rewards on rewards list

# Use to set a data value, the corresponding param will be define on the recover function
func setData(_additionalData: String) -> void :
	pass

## Init total weight
func initWeight() -> void :
	totalWeight = 0
	for rewardId in rewardsAvailable:
		totalWeight += rewardsAvailable[rewardId].weight


## Randomize rewards 
func randomizeRewards() -> void: 
	rewards.clear()#Clear old choice
	#Add 3 randoms items of rewardsAvailable into rewards
	var i : int = 0
	while i < rewardsNumber :
		rewards.append(pickReward())
		i += 1
	print("REWARDS")
	print(rewards)

func pickReward() -> String :
	var random = randi() % totalWeight
	var current = 0
	var tile: AbstractTile
	
	for rewardId in rewardsAvailable:
		current += rewardsAvailable[rewardId].weight
		if random < current:
			return rewardId
	return ""

## Return the screen reward, will be called on player to place it on interface
func getScreenReward() -> RewardChoiceInterface:
	var interface: RewardChoiceInterface = rewardInterface.instantiate()
	interface.reward = self
	return interface

## Use when selecting a reward, maybe will be placed on an interface
func obtainReward(player: AbstractPlayer, number: int) -> bool :
	if number == -1 : 
		skipReward()
		return true# Need a return to avoid going to the rest of function and getting the last element even with queue_free() in skipReward()
	var rewardId: String = rewards[number]
	var reward: Dictionary = RewardDb.REWARDS_DICO[rewardId]
	match reward["rewardType"] :
		RewardTypes.rewardTypes.UNIT :
			print("OBTAIN IT")
			GameManager.getMainPlayer().gainUnitCard(StoredUnit.new(reward["idReward"]))
		RewardTypes.rewardTypes.ITEM :
			GameManager.getMainPlayer().addCard(reward["idReward"])
		RewardTypes.rewardTypes.TRINKET :
			GameManager.addTrinket(GameManager.getMainPlayer(), reward["idReward"])
		RewardTypes.rewardTypes.GOLD :
			GameManager.getMainPlayer().gainGold(totalWeight)
		RewardTypes.rewardTypes.ORB :
			GameManager.getMainPlayer().addCard(reward["orbAmt"])
		RewardTypes.rewardTypes.BONUS :
			openUnitSelectionForUpgrade(rewardId)
			return false # Don't close interface
			# GameManager.getMainPlayer().addCard(reward["idReward"])	#Will need one more thing to attribute the bonus to an unit
	queue_free()
	return true # Close interface

## We will add trinkets effects here if some activates on skip
func skipReward() -> void:
	queue_free()


# -- Methods to manage bonus interface --
var currentChoiceInterface: RewardChoiceInterface

func openUnitSelectionForUpgrade(bonusId: String) -> void:
	# On instancie la nouvelle interface
	var selectionUI: BonusUnitSelectionInterface = preload("res://nodes/interface/metaUI/placeholderScreens/rewardUpgradeUnitSelectionInterface.tscn").instantiate()
	selectionUI.setup(bonusId, self)
	
	var metaUI = GameManager.getMainPlayer().metaInterface
	
	# On cache l'écran des 3 choix (sans le détruire)
	# Assure-toi d'avoir stocké la référence quand getScreenReward() a été appelé, 
	# ou cherche-la dans les enfants du MetaUI
	for child in metaUI.get_children():
		if child is RewardChoiceInterface:
			child.visible = false
			currentChoiceInterface = child
			
	# On place notre nouvel écran de sélection par-dessus
	metaUI.add_child(selectionUI)

func confirmBonusSelection() -> void:
	# Clean up interfaces
	if is_instance_valid(currentChoiceInterface):
		currentChoiceInterface.closeRewardInterface() # Close First Reward Interface
	queue_free() # Détruit le script AbstractReward (déclenche la récompense suivante)

func cancelBonusSelection() -> void:
	# Le joueur a cliqué sur "Retour" (en haut à gauche)
	# On réaffiche l'écran des 3 choix de récompense
	if is_instance_valid(currentChoiceInterface):
		currentChoiceInterface.visible = true
