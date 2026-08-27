extends AbstractTrinket
class_name FairyBenediction

# Heal 2 random wounded unit for 4 each turn 
# à voir si c'est vraiment trop nul

const idItem = "set1:FairyBenediction"
const img = "res://assets/sprites/trinkets/BananaRecipes"
const HEAL_AMT = 4
const NBR_UNITS_TO_HEAL = 2

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_COMMON, playerAssociated, HEAL_AMT, NBR_UNITS_TO_HEAL)


func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if turnColor == playerAssociated.team :
		var unitToHeal: AbstractUnit = GameManager.getRandomUnits(value_B, [], turnColor).front() # Use of front to avoid cases with 0 units finded
		if unitToHeal != null :
			unitToHeal.healHp(value_A)
