extends Control
class_name BonusUnitSelectionInterface

## TODO Recheck le code de Gemini

var bonusId: String
var parentReward: AbstractReward

# On configure l'interface quand on l'instancie
func setup(_bonusId: String, _parentReward: AbstractReward) -> void:
	self.bonusId = _bonusId
	self.parentReward = _parentReward
	displayUnits()

func displayUnits() -> void:
	var unitsStock = GameManager.getMainPlayer().hand.getUnitsStocked()
	
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
		

		# Connect button to the upgrade selection if unit haven't already reach potential limit
		if usedPotential < finalPotential :
			btn.pressed.connect(func(): _onUnitSelected(storedUnit))
		else :
			btn.disabled = true # Disable button if unit has reached its max potential
		%UnitsList.add_child(btn)

func _onUnitSelected(unitData: StoredUnit) -> void:
	# Add bonus and apply stats change 
	unitData.addPermanentUpgrade(bonusId)
	
	print("Bonus " + bonusId + " appliqué à " + unitData.id)
	
	# 2. On prévient la récompense parente que c'est fini
	parentReward.confirmBonusSelection()
	self.queue_free() # Remove this interface

## Hide interface and return to select bonus to get
func _onTopLeftBtn_pressed() -> void:
	# Cancel bonus selection and delete this interface
	bonusId = ""
	parentReward.cancelBonusSelection()
	self.queue_free()
