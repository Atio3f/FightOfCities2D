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

	## Iterate equipments from player hand
	for idEquip: String in player.hand.equipmentsStock:
		_addStockSlot(idEquip)


## Display the currently equipped item in EquipedItemContainer, click to unequip
func _addEquippedSlot(idEquip: String) -> void:
	var btn: ItemDisplay = equipBtnScene.instantiate()
	%EquipedItemContainer.add_child(btn)

	## Display item (handles image + name + description)
	btn.toggleItems(idEquip, _player, self, self.unit)

	# Marqueur visuel : équipement actuellement porté
	## TODO Plus logique de le mettre dans Item Display nan ?
	if btn.has_node("%NameItem"):
		btn.get_node("%NameItem").text = btn.get_node("%NameItem").text + "(Équipé)"

	var itemBtn: Button = btn.get_node("%ItemBtn")

	# Clic → déséquiper : remet l'équipement dans le stock du joueur
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


## Display an equipment from the player's stock in ItemList, click to equip
func _addStockSlot(idEquip: String) -> void:
	var btn: ItemDisplay = equipBtnScene.instantiate()
	%ItemList.add_child(btn)

	## Display item (handles image + name + description)
	btn.toggleItems(idEquip, _player, self, self.unit)

	var itemBtn: Button = btn.get_node("%ItemBtn")
	
	# Vérification : peut-on équiper cet équipement sur cette unité ?
	if not ItemDb.ITEMS.has(idEquip):
		itemBtn.disabled = true
		return

	var equipInstance: AbstractEquipment = ItemDb.ITEMS[idEquip].new()
	var canEquip: bool = unit.canEquipEquipment(equipInstance)
	equipInstance.queue_free()

	itemBtn.disabled = !canEquip

	if canEquip:
		# Clic → équiper via le GameManager (gère le déshabillage + application des stats)
		itemBtn.button_up.connect(func():
			GameManager.equipEquipmentOnUnit(idEquip, _player, unit)
			closeInterface()
		)


func closeInterface() -> void:
	queue_free()
