extends MarginContainer
class_name ItemDisplay

signal activation_item(inventoryInterface: Control)
var associatedId: String
var playerStocked: AbstractPlayer
var unitStocked: AbstractUnit # Stock unit when inventory is open from an unit

## Display item on inventory
# inventoryInterface is the interface where is displayed this item Btn
func toggleItems(itemId: String, player: AbstractPlayer, inventoryInterface: Control, unit: AbstractUnit = null) -> void :
	%PreviewItem.visible = false
	%NameItem.visible = false
	associatedId = itemId
	playerStocked = player
	unitStocked = unit
	if itemId != "" :
		var itemData: Dictionary = ItemDb.getItem(itemId)
		%PreviewItem.text = tr(itemData["description"])
		%NameItem.text = tr(itemData["name"])
		%ItemBtn.icon = load(itemData["img"])
	else :
		%ItemBtn.icon = load("res://assets/sprites/items/BrambleGauntlet.png")
	
	if(!ItemDb.ITEMS.has(itemId)) :
		%ItemBtn.disabled = true
	else :
		# Disable ItemBtn if card isn't playeable
		var isDisabled: bool = true
		# Using item on an unit
		if unit != null :
			var itemInstance: AbstractItem = ItemDb.ITEMS[itemId].new()
			if itemInstance is AbstractEquipment:
				isDisabled = !unit.canEquipEquipment(itemInstance)
			else:
				isDisabled = !itemInstance.canBeUsedOnUnit(player, unit, itemInstance.orbCost)
			itemInstance.queue_free()
			%ItemBtn.disabled = isDisabled
			if !isDisabled :
				activation_item.connect(inventoryInterface.closeInterface)
		# Using item from inventory or on an empty tile
		else :
			var item: AbstractItem = ItemDb.ITEMS[itemId].new()
			match item.getTargetType():
				ItemTargets.itemTargets.PLAYER:
					isDisabled = !item.canBeUsedOnInventory(player, item.orbCost)
					pass
				ItemTargets.itemTargets.TILE:
					isDisabled = !item.canBeUsedOnTile(player, null, item.orbCost)
					pass
				_:
					isDisabled = true
			%ItemBtn.disabled = isDisabled


func _on_item_btn_mouse_entered():
	%PreviewItem.visible = true
	%NameItem.visible = true


func _on_item_btn_mouse_exited():
	%PreviewItem.visible = false
	%NameItem.visible = false

## When clicking on the item button
func _on_item_btn_button_up():
	# Use directly on an unit
	print(unitStocked != null)
	if unitStocked != null:
		var itemInstance: AbstractItem = ItemDb.ITEMS[associatedId].new()
		if itemInstance is AbstractEquipment:
			GameManager.equipEquipmentOnUnit(associatedId, playerStocked, unitStocked)
		else:
			GameManager.useItemOnUnits(associatedId, playerStocked, [unitStocked])
		itemInstance.queue_free()
		activation_item.emit()
	# When needing to select target or simply have 
	else :
		pass
