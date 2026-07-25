extends Control
class_name UnitEquipmentsInterface

var equipBtnScene: PackedScene = preload("res://nodes/Unite/interfaceUnite/ItemDisplayInterface.tscn")

var unit: AbstractUnit
var _player: AbstractPlayer

## Display equipments from player
func showEquipments(unit: AbstractUnit, player: AbstractPlayer) -> void:
	self.unit = unit
	_player = player

	## Display equipment currently on unit
	_addEquipmentSlot(unit.equipment.getId() if unit.equipment != null else "", true)

	## Iterate equipments from player hand
	for idEquip: String in player.hand.equipmentsStock:
		_addEquipmentSlot(idEquip, false)


## Create and add equipment button to the list
## equippedOnUnit : true if it's the equipment currently worn by the unit
func _addEquipmentSlot(idEquip: String, equippedOnUnit: bool) -> void:
	var btn: ItemDisplay = equipBtnScene.instantiate()
	%ItemList.add_child(btn)

	## Display item (handles image + name + description)
	btn.toggleItems(idEquip, _player, self, self.unit)

	## Override button behavior for equipments
	if equippedOnUnit:
		_setupEquippedSlot(btn, idEquip)
	else:
		_setupStockSlot(btn, idEquip)


## Configure un slot représentant l'équipement actuellement porté
## Permet de le déséquiper (remet l'équipement dans le stock)
func _setupEquippedSlot(btn: ItemDisplay, idEquip: String) -> void:
	var itemBtn: Button = btn.get_node("%ItemBtn")

	# Slot vide : désactivé si aucun équipement n'est porté
	if idEquip == "":
		itemBtn.disabled = true
		if btn.has_node("%NameItem"):
			btn.get_node("%NameItem").text = "[ Vide ]"
		return

	# Marqueur visuel : équipement actuellement porté
	if btn.has_node("%NameItem"):
		btn.get_node("%NameItem").text = "[Équipé] " + btn.get_node("%NameItem").text

	# Clic → déséquiper : remet l'équipement dans le stock du joueur
	itemBtn.button_up.connect(func():
		if unit.equipment != null:
			var unequippedId: String = unit.equipment.getId()
			unit.equipment.onUnequip()
			unit.equipment = null
			_player.hand.equipmentsStock.append(unequippedId)
			closeInterface()
	)


## Configure un slot représentant un équipement disponible dans le stock
## Permet de l'équiper sur l'unité
func _setupStockSlot(btn: ItemDisplay, idEquip: String) -> void:
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
