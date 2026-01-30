extends Button
class_name RewardBtnInterface

var rewards: AbstractReward
var rewardNbr: int

static var BG_COLOR := "1414145e"

## Nbr is the place on rewards
# TODO Pq c'est rewards et non reward ?
func generate(rewards: AbstractReward, nbr: int) -> void :
	var rewardId: String = rewards.rewards[nbr]
	var reward: Dictionary = RewardDb.REWARDS_DICO[rewardId]
	self.rewardNbr = nbr
	self.rewards = rewards
	#Missing icon reward
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


func _on_mouse_exited():
	%DescReward.visible = false


func _on_pressed():
	rewards.obtainReward(GameManager.getMainPlayer(), rewardNbr)
	print("GET IT")
	get_parent().get_parent().closeRewardInterface()	#Close interface
