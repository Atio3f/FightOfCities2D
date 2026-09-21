extends Button
class_name RewardBtnInterface

var rewards: AbstractReward
var rewardNbr: int

var info_card_instance: UnitInfoCard = null

static var BG_COLOR := "1414145e"

# Define base path to get icons for each reward type
const ICON_BASE_PATHS = {
	RewardTypes.rewardTypes.UNIT: "res://assets/sprites/units/",
	RewardTypes.rewardTypes.TRINKET: "res://assets/sprites/trinkets/",
	RewardTypes.rewardTypes.EQUIPMENT: "res://assets/sprites/items/",
	RewardTypes.rewardTypes.ITEM: "res://assets/sprites/items/",
	RewardTypes.rewardTypes.BONUS: "res://assets/sprites/upgrades/",
	RewardTypes.rewardTypes.GOLD: "res://assets/sprites/icons/"
}

## Nbr is the place on rewards
func generate(rewards: AbstractReward, nbr: int) -> void :
	var rewardData: Variant = rewards.rewards[nbr]
	var rewardId: String = ""
	
	if typeof(rewardData) == TYPE_OBJECT and rewardData is StoredUnit:
		rewardId = rewardData.id
	else:
		rewardId = rewardData as String
		
	var reward: Dictionary = RewardDb.REWARDS_DICO[rewardId]
	self.rewardNbr = nbr
	self.rewards = rewards
	
	if reward.has("icon_name") and reward["icon_name"] != "":
		var base_path = ICON_BASE_PATHS.get(reward["rewardType"], "res://assets/sprites/interface/icons/")
		var full_path = base_path + reward["icon_name"]
		self.icon = load(full_path)
	else:
		self.icon = load("res://assets/sprites/units/Monkey_p.png")
		
	%DescReward.visible = false
	%TitleReward.text = reward["title"]
	%DescReward.text = reward["desc"]
	
	## Apply border color
	var border = get_theme_stylebox("normal").duplicate() as StyleBoxFlat
	
	# Config bgColor
	border.bg_color = Color(BG_COLOR)
	# Config border size
	border.border_width_left = 3
	border.border_width_top = 3
	border.border_width_right = 2
	border.border_width_bottom = 2
	
	# Apply color
	if rewards.rewardsAvailable.has(rewardId) :
		var rewardInfos : RarityData = rewards.rewardsAvailable[rewardId]
		print(rewards.rewardsAvailable)
		print(rewards.rewardsAvailable[rewardId])
		border.border_color = rewardInfos.color
	else :
		border.border_color = Color(Rarities.RARITY_COLORS["COMMON"]) # Default color if no rarity or rarity color not found
	# Apply border to reward btn
	add_theme_stylebox_override("normal", border)
	# Also add to hovered style to avoid change
	add_theme_stylebox_override("hover", border)

func _on_mouse_entered():
	%DescReward.visible = true
	
	var rewardData: Variant = rewards.rewards[rewardNbr]
	var rewardId: String = ""
	var storedUnit: StoredUnit = null
	
	if typeof(rewardData) == TYPE_OBJECT and rewardData is StoredUnit:
		storedUnit = rewardData
		rewardId = storedUnit.id
	else:
		rewardId = rewardData as String
		
	var reward: Dictionary = RewardDb.REWARDS_DICO[rewardId]
	if reward.has("rewardType") and reward["rewardType"] == RewardTypes.rewardTypes.UNIT:
		if not is_instance_valid(info_card_instance):
			var scene = load("res://nodes/interface/UnitInfoCard.tscn")
			if scene:
				info_card_instance = scene.instantiate()
				add_child(info_card_instance)
			else:
				push_error("Failed to load UnitInfoCard.tscn")
			
		if is_instance_valid(info_card_instance):
			# Create a new stored unit for each unit reward on list
			info_card_instance.setup_from_stored_unit(storedUnit)
			info_card_instance.visible = true
			info_card_instance.placementTopRight()

func _on_mouse_exited():
	%DescReward.visible = false
	if is_instance_valid(info_card_instance):
		info_card_instance.visible = false


func _on_pressed():
	var shouldClose: bool = rewards.obtainReward(GameManager.getMainPlayer(), rewardNbr)
	print("GET IT")
	if shouldClose : get_parent().get_parent().closeRewardInterface()	#Close interface
