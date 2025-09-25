extends MarginContainer
class_name ItemDisplay


func toggleItems(itemId: String, player: AbstractPlayer, unit: AbstractUnit = null) -> void :
	if itemId != "" && Global.itemsStrings["en"].has(itemId):
		var itemStrings : Dictionary = Global.itemsStrings["en"][itemId]
		%PreviewItem.text = itemStrings["DESC"]
		%NameItem.text = itemStrings["NAME"]
		%ItemBtn.icon = load(itemStrings["IMG"])
	else :
		%ItemBtn.icon = load("res://assets/sprites/items/BrambleGauntlet.png")
	
	if(!ItemDb.ITEMS.has(itemId)) :
		%ItemBtn.disabled = true
	else :
		#Disable ItemBtn if card isn't playeable
		if unit != null :
			%ItemBtn.disabled = !ItemDb.ITEMS[itemId].canBeUsedOnUnit(player, unit)
		else :
			%ItemBtn.disabled = player.cardCanBePlayedInventory(itemId)


func _on_item_btn_mouse_entered():
	%PreviewItem.visible = true


func _on_item_btn_mouse_exited():
	%PreviewItem.visible = false
