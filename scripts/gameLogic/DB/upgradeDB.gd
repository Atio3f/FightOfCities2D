## Stock all buffs from bonus
extends Node
class_name UpgradeDB

## Example of data structure : {idUpgrade: {"stats": [], "is_dynamic": boolean} -> is_dynamic allow to avoid calling all function for effects
static var data : Dictionary


static func get_stat_modifiers(id: String) -> Dictionary:
	if !data : loadUpgradesData() # Load data for upgrades if it have not be done
	if data.has(id):
		return data[id].get("stats", {})
	return {}

static func loadUpgradesData() -> void :
	data = Global.loadStrings("res://Ressources/upgrades/upgradesData.json")
