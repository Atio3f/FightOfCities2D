extends Control
class_name BonusUnitSelectionInterface

var bonusId: String
var parentReward: AbstractReward
var info_card_instance: Node = null

# On configure l'interface quand on l'instancie
func setup(_bonusId: String, _parentReward: AbstractReward = null) -> void:
	self.bonusId = _bonusId
	self.parentReward = _parentReward
	displayUnits()

func displayUnits() -> void:
	for child in %UnitsList.get_children():
		child.queue_free()

	var unitsStock = GameManager.getMainPlayer().hand.getUnitsStocked()
	
	var upgradeStats = UpgradeDB.get_stat_modifiers(bonusId)
	var upgradePotentialCost = upgradeStats.get("potentialCost", 999)
	assert(upgradePotentialCost != 999, "Upgrade potential cost not found")
	
	# Display bonus name and potential cost in header
	var effectData = EffectDb.getEffectData(bonusId) if EffectDb else {}
	var bonusName = tr(effectData.get("name", bonusId)) if not effectData.is_empty() else bonusId
	if has_node("%TitleLabel"):
		%TitleLabel.text = tr("Select a unit for: ") + bonusName
	if has_node("%CostLabel"):
		%CostLabel.text = tr("Potential cost: ") + str(int(upgradePotentialCost))
	
	var eligibleUnitsCount: int = 0
	
	for storedUnit: StoredUnit in unitsStock:
		# Get unit data
		var unitData: UnitStats = UnitDb.getUnitStats(storedUnit.id)
		var unitName = UnitDb.getUnit(storedUnit.id).get("name", "ERROR") # ou unitData.name si c'est directement l'objet
		
		# Get its potential
		var basePotential: int = unitData.get("potential") if unitData else 50
		# Calc final potential with the stat modifiers
		var finalPotential: int = basePotential
		if storedUnit.statModifiers.has("potential"):
			finalPotential += storedUnit.statModifiers["potential"]
		## Will need to find an other way to calculate used potential bc some upgrades will cost more than 1 potential
		var usedPotential: int = storedUnit.statModifiers.get("potentialCost", 0)
		
		# Check if unit has enough potential to equip this upgrade
		var canEquip: bool = (usedPotential + upgradePotentialCost) <= finalPotential || (upgradePotentialCost <= 0 && basePotential != 0)
		if not canEquip:
			continue # Hide units that cannot equip this upgrade
		
		eligibleUnitsCount += 1
		var btn = Button.new()
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		# Display remaining potential on button along with upgrade cost
		btn.text = tr(unitName) + tr("\n Remaining potential : ") + str(usedPotential) + "/"+ str(finalPotential) # + tr(" (Cost: ") + str(int(upgradePotentialCost)) + ")" # Dans le cas où des upgrades pourraient coûter plus cher selon certains critères d'unité
		btn.pressed.connect(func(): _onUnitSelected(storedUnit))
			
		## Hover preview for the unit info card
		btn.mouse_entered.connect(func(): _on_btn_mouse_entered(storedUnit))
		btn.mouse_exited.connect(_on_btn_mouse_exited)
		
		%UnitsList.add_child(btn)

	if eligibleUnitsCount == 0:
		var emptyLabel = Label.new()
		emptyLabel.text = tr("No unit has enough potential for this upgrade.")
		emptyLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		%UnitsList.add_child(emptyLabel)
		
func _on_btn_mouse_entered(storedUnit: StoredUnit) -> void:
	if not is_instance_valid(info_card_instance):
		var scene = load("res://nodes/interface/UnitInfoCard.tscn")
		if scene:
			info_card_instance = scene.instantiate()
			add_child(info_card_instance)
		else:
			push_error("Failed to load UnitInfoCard.tscn")
			
	if is_instance_valid(info_card_instance):
		info_card_instance.setup_from_stored_unit(storedUnit)
		info_card_instance.visible = true
		info_card_instance.placementTopRight()

func _on_btn_mouse_exited() -> void:
	if is_instance_valid(info_card_instance):
		info_card_instance.visible = false

func _onUnitSelected(unitData: StoredUnit) -> void:
	# Add bonus and apply stats change 
	unitData.addPermanentUpgrade(bonusId)
	
	print("Bonus " + bonusId + " appliqué à " + unitData.id)
	
	# 2. On prévient la récompense parente que c'est fini
	if parentReward:
		parentReward.confirmBonusSelection()
	self.queue_free() # Remove this interface


## Hide interface and return to select bonus to get
func _on_return_btn_pressed() -> void:
	# Cancel bonus selection and delete this interface
	bonusId = ""
	if parentReward :
		parentReward.cancelBonusSelection()
	self.queue_free()
