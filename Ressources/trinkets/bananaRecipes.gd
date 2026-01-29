class_name BananaRecipes extends AbstractTrinket

#Gain 3 orb on obtain
const idItem = "set1:BananaRecipes"
const img = "res://assets/sprites/trinkets/BananaRecipes"
const BANANA_GAIN = 2
const HEAL_BANANA = 3

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_UNCOMMON, playerAssociated, BANANA_GAIN, HEAL_BANANA)


func onGain() -> void :
	var i = 0
	while i < value_A :
		playerAssociated.addCard("set1:Banana")
		i += 1

func onItemUsed(player: AbstractPlayer, isMalus: bool, unit: AbstractUnit = null) -> void:
	pass
	#Manque l'info sur l'objet ouu???
