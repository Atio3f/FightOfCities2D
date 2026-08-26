extends Control
class_name UnitEquipmentsInterface

var equipBtnScene: PackedScene = preload("res://nodes/Unite/interfaceUnite/ItemDisplayInterface.tscn")

var unit: AbstractUnit
var _player: AbstractPlayer

## Display equipments from player
func showEquipments(unit: AbstractUnit, player: AbstractPlayer) -> void:
	self.unit = unit
	_player = player
	
	## Display equipment currently on unit or empty slot to place on top
	if unit.equipment != null:
		_addEquippedSlot(unit.equipment.getId())
	else:
		_addEmptySlot()
	
	# Equipments in inventory
	for idEquip: String in player.hand.equipmentsStock :
		_addStockSlot(idEquip)

	# Equipments of units in play
	var activeUnits: Array[AbstractUnit] = player.getUnits()
	for activeU: AbstractUnit in activeUnits:
		if activeU.equipment != null and activeU != unit:
			_addStockSlot(activeU.equipment.getId(), activeU.getImagePath(), activeU, null)

	# Equipments of stored units
	var storedUnits: Array[StoredUnit] = player.hand.unitsStock
	for storedU: StoredUnit in storedUnits:
		for eqData in storedU.equipmentsData:
			if eqData.has("id"):
				var stats = UnitDb.getUnitStats(storedU.id)
				var imgPath = "res://assets/sprites/units/" + stats.imgPath if stats else ""
				_addStockSlot(eqData["id"], imgPath, null, storedU)


## Display the currently equipped item in EquipedItemContainer, click to unequip
func _addEquippedSlot(idEquip: String) -> void:
	var btn: ItemDisplay = equipBtnScene.instantiate()
	%EquipedItemContainer.add_child(btn)

	## Display item
	btn.toggleItems(idEquip, _player, self, self.unit)

	var itemBtn: Button = btn.get_node("%ItemBtn")

	# Allow to unequip equipment when clicked
	itemBtn.button_up.connect(func():
		if unit.equipment != null:
			unit.unequipEquipment()
			closeInterface()
	)


## Display empty equipment slot placeholder
func _addEmptySlot() -> void:
	var label: Label = Label.new()
	label.text = "Emplacement d'équipement vide"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	%EquipedItemContainer.add_child(label)


func _addStockSlot(idEquip: String, equippedUnitImgPath: String = "", sourceActiveUnit: AbstractUnit = null, sourceStoredUnit: StoredUnit = null) -> void:
	var btn: ItemDisplay = equipBtnScene.instantiate()
	%ItemList.add_child(btn)

	## Display item
	btn.toggleItems(idEquip, _player, self, self.unit, equippedUnitImgPath)

	var itemBtn: Button = btn.get_node("%ItemBtn")
	
	# Check if equipment can be equipped on this unit
	if not ItemDb.ITEMS.has(idEquip):
		itemBtn.disabled = true
		return

	var equipInstance: AbstractEquipment = ItemDb.ITEMS[idEquip].new()
	var canEquip: bool = unit.canEquipEquipment(equipInstance)
	equipInstance.queue_free()

	itemBtn.disabled = !canEquip

	if canEquip:
		# Equip equipment on unit via GameManager (handles unequip + stats application)
		itemBtn.button_up.connect(func():
			GameManager.equipEquipmentOnUnit(idEquip, _player, unit, sourceActiveUnit, sourceStoredUnit)
			closeInterface()
		)


func closeInterface() -> void:
	queue_free()
