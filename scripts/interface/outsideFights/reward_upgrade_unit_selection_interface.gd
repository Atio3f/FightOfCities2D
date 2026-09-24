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
	var unitsStock = GameManager.getMainPlayer().hand.getUnitsStocked()
	
	var upgradeStats = UpgradeDB.get_stat_modifiers(bonusId)
	var upgradePotentialCost = upgradeStats.get("potentialCost", 999)
	assert(upgradePotentialCost != 999, "Upgrade potential cost not found")
	
	for storedUnit: StoredUnit in unitsStock:
		var btn = Button.new()
		
		# Get unit data
		var unitData: UnitStats = UnitDb.getUnitStats(storedUnit.id)
		var unitName = UnitDb.getUnit(storedUnit.id).get("name", "ERROR") # ou unitData.name si c'est directement l'objet
		
		# Get its grade
		#var baseGrade = unitData.get("grade", 50)
		
		#Calc final grade with the stat modifiers
		#var finalGrade = baseGrade
		#if storedUnit.statModifiers.has("grade"):
		#	finalGrade += storedUnit.statModifiers["grade"]
		
		# Get its potential
		var basePotential: int = unitData.get("potential") if unitData else 50
		# Calc final potential with the stat modifiers
		var finalPotential: int = basePotential
		if storedUnit.statModifiers.has("potential"):
			finalPotential += storedUnit.statModifiers["potential"]
		## Will need to find an other way to calculate used potential bc some upgrades will cost more than 1 potential
		var usedPotential: int = storedUnit.statModifiers.get("potentialCost", 0)
		
		# Display remaining potential on button
		btn.text = tr(unitName) + "\n Remaining potential : " + str(usedPotential) + "/"+ str(finalPotential) 
		
		# Connect button to the upgrade selection if unit haven't already reach potential limit or if upgrade cost 0
		if (usedPotential + upgradePotentialCost) <= finalPotential || (upgradePotentialCost <= 0 && basePotential != 0):
			btn.pressed.connect(func(): _onUnitSelected(storedUnit))
		else :
			btn.disabled = true # Disable button if unit has reached its max potential
			
		## Hover preview for the unit info card
		btn.mouse_entered.connect(func(): _on_btn_mouse_entered(storedUnit))
		btn.mouse_exited.connect(_on_btn_mouse_exited)
		
		%UnitsList.add_child(btn)
		
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
