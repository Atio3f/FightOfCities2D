extends Control
class_name UnitItemsInterface

var itemBtnScene: PackedScene = preload("res://nodes/Unite/interfaceUnite/ItemDisplayInterface.tscn")

func showItems(unit: AbstractUnit, player: AbstractPlayer)-> void :#Y'avait un boolean aussi mais jsp à quoi il sert
	##Get all playeable cards in hand
	#Need to be changed to only check card for the unit
	var cards: Array[String] = player.getUsableCardsInventory()
	var itemBtn : ItemDisplay	#var type A CHANGER QUAND ON AURA UN SCRIPT A Item Btn
	##Iterate cards to disable non playeable once
	for idCard: String in cards :
		#Create a ItemBtn
		itemBtn = itemBtnScene.instantiate()
		itemBtn.toggleItems(idCard, player, self, unit)
		#Place ItemBtn
		%ItemList.add_child(itemBtn)

func closeInterface() -> void :
	queue_free()
