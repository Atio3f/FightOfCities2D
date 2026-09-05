class_name AbstractShop
extends RefCounted

var vendor_id: String = ""
var background_id: String = ""
var available_items: Array = []

# Variance du prix des objets du shop vendus
var priceMinThreshold: float = 0.95
var priceMaxThreshold: float = 1.10
var layout_columns: int = 1

func _init() -> void:
	pass

# Need to be override
func generate_items() -> void:
	assert(false, "generate_items() must be implemented in the derived class")

func populate_shop(items: Array) -> void:
	available_items.clear()
	for item_id in items:
		if RewardDb.REWARDS_DICO.has(item_id):
			var reward_data = RewardDb.REWARDS_DICO[item_id]
			var base_price = reward_data.get("price", -1)
			
			if base_price == -1:
				if reward_data.has("rarity") and reward_data["rarity"] != null:
					base_price = reward_data["rarity"].price
				else:
					base_price = 100 # Fallback 
			
			# Randomize price between thresholds
			var randomized_price = int(round(base_price * randf_range(priceMinThreshold, priceMaxThreshold)))
			
			available_items.append({"id": item_id, "price": randomized_price})
		else:
			push_error("item_id not found : " + item_id)

func populate_from_layout(layout: String) -> void:
	available_items.clear()
	var lines = []
	if not "\\" in layout and "\n" in layout:
		lines = layout.split("\n")
	else:
		lines = layout.split("\\")
		
	layout_columns = 0
	
	for line in lines:
		if line.length() > layout_columns:
			layout_columns = line.length()
			
		for char in line:
			if char == " ":
				available_items.append({"id": "", "price": 0})
			else:
				var type_filter = -1
				match char.to_lower():
					"i": type_filter = RewardTypes.rewardTypes.ITEM
					"e": type_filter = RewardTypes.rewardTypes.EQUIPMENT
					"u": type_filter = RewardTypes.rewardTypes.UNIT
					"t": type_filter = RewardTypes.rewardTypes.TRINKET
				
				if type_filter != -1:
					var picked_id = pick_random_reward_by_type(type_filter)
					if picked_id != "":
						var reward_data = RewardDb.REWARDS_DICO[picked_id]
						var base_price = reward_data.get("price", -1)
						if base_price == -1:
							if reward_data.has("rarity") and reward_data["rarity"] != null:
								base_price = reward_data["rarity"].price
							else:
								base_price = 100
						var randomized_price = int(round(base_price * randf_range(priceMinThreshold, priceMaxThreshold)))
						available_items.append({"id": picked_id, "price": randomized_price})
					else:
						available_items.append({"id": "", "price": 0})
				else:
					available_items.append({"id": "", "price": 0})

func pick_random_reward_by_type(target_type: int) -> String:
	var valid_ids = []
	for key in RewardDb.REWARDS_DICO.keys():
		var data = RewardDb.REWARDS_DICO[key]
		if data.has("rewardType") and data["rewardType"] == target_type:
			valid_ids.append(key)
			
	if valid_ids.size() > 0:
		return valid_ids[randi() % valid_ids.size()]
	return ""

func buy_item(player: AbstractPlayer, item_index: int) -> bool:
	if item_index < 0 or item_index >= available_items.size():
		return false
		
	var shop_item = available_items[item_index]
	var item_id = shop_item.id
	var item_price = shop_item.price
	
	if player.gold >= item_price:
		player.gainGold(-item_price)
		
		var reward_data = RewardDb.REWARDS_DICO[item_id]
		
		match reward_data["rewardType"]:
			RewardTypes.rewardTypes.UNIT:
				player.gainUnitCard(StoredUnit.new(item_id))
			RewardTypes.rewardTypes.ITEM, RewardTypes.rewardTypes.EQUIPMENT:
				player.addCard(item_id)
			RewardTypes.rewardTypes.TRINKET:
				GameManager.obtainTrinket(player, item_id)
			RewardTypes.rewardTypes.GOLD:
				player.gainGold(reward_data.get("amount", 0))
			RewardTypes.rewardTypes.ORB:
				player.addCard(reward_data.get("orbAmt", 0))
			
		available_items.remove_at(item_index)
		
		if Global.has_user_signal("update_gold"):
			Global.update_gold.emit(player.gold)
			
		return true
		
	return false
