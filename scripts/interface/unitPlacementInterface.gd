class_name unitPlacementInterface extends MarginContainer

var storedUnitData: StoredUnit
var player: AbstractPlayer = GameManager.getMainPlayer()
var coords: Vector2i #Coords of the interface tile

## Set the unit preview label and texture
func setUnitPreview(unit: AbstractUnit, storedUnitData: StoredUnit, coords: Vector2i) -> void :
	self.storedUnitData = storedUnitData # Could be optimized by refering first param by storedUnitData instead of unit in the function, problem is that we need grade on other class
	self.coords = coords
	var unitData: Dictionary = UnitDb.getUnit(storedUnitData.id)
	var stats = UnitDb.getUnitStats(storedUnitData.id)
	var weight: int = stats.grade + storedUnitData.statModifiers.get("grade", 0)
	
	%Preview.text = getPreviewText(tr(unitData["name"]), weight)
	if unit.STATS.imgPath != null and unit.STATS.imgPath != "" :
		%BtnUnit.icon = load(unit.getImagePath()+"_p.png")
		
	if storedUnitData.equipmentsData.size() > 0:
		var eqId = storedUnitData.equipmentsData[0].get("id", "")
		var itemDbNode = Engine.get_main_loop().root.get_node_or_null("ItemDb")
		if itemDbNode != null and itemDbNode.ITEMS.has(eqId):
			var eqInstance = itemDbNode.ITEMS[eqId].new()
			%EquipmentIcon.texture = load(eqInstance.getImagePath())
			%EquipmentIcon.show()
	else:
		%EquipmentIcon.hide()

	# Disable the button if player haven't enough weight or have max units reached to place it
	if !GameManager.unitCanBePlacedOnTile(player, MapManager.getTileAt(coords), weight) or not player.maxUnits > player.units.size():
		disableBtn()

## Add a preview text on top
func getPreviewText(name: String, weight: int) -> String :
	var finalText : String = name + "\nWeight "+ str(weight)
	return finalText

func _on_btn_unit_button_up():
	if %BtnUnit.disabled: return # Avoid double click
	%BtnUnit.disabled = true
	#Check if we're on a preparation turn
	if TurnManager.turn == 0:
		Global.gameManager.placeUnit(storedUnitData, player, MapManager.getTileAt(coords))
		player.hand.unitsStock.erase(storedUnitData)
		player.playerPointer.clear_placeable_cells(coords)#Clear the tile
	else :
		print("NOT YOUR TURN")	#Will need a pop up message later
	deleteInterface()

func disableBtn() -> void:
	%BtnUnit.disabled = true

func deleteInterface() -> void:
	player.playerPointer.interfaceJoueurI.clearInterface()
