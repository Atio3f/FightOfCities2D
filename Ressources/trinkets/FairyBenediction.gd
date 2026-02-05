extends AbstractTrinket
class_name FairyBenediction

# Heal one random wounded unit for 4 each turn 
# à voir si c'est vraiment trop nul

const idItem = "set1:FairyBenediction"
const img = "res://assets/sprites/trinkets/BananaRecipes"
const HEAL_AMT = 4

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_COMMON, playerAssociated, HEAL_AMT)


func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if turnColor == playerAssociated.team :
		var unitToHeal: AbstractUnit = GameManager.getRandomUnits(1, [], turnColor).front() # Use of front to avoid cases with 0 units finded
		if unitToHeal != null :
			unitToHeal.healHp(value_A)
