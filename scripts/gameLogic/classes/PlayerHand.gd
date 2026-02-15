extends Node
class_name PlayerHand
#Contains all cards that the player have in his inventory

var cards: Array[String] = []#Contains all id cards
var player: AbstractPlayer
var cardsPlayed: Array[String] = []
var maxSize: int = 10	#Nombre de cartes dans la main possible, inutilisé pour le moment
var unitsStock: Array[StoredUnit] = []
func _init(playerAssociated: AbstractPlayer):
	self.player = playerAssociated

#Add a card to hand
func addCard(idCard: String) -> void:
	cards.append(idCard)

#Add a unit on your stock
func addUnitCard(storedUnitData: StoredUnit) -> void:
	unitsStock.append(storedUnitData)

#Remove the card from the hand if the card can be played
func useCard(idCard: String) -> void:
	cards.erase(idCard)
	cardsPlayed.append(idCard)

func getHand() -> Array[String]:
	return cards

func getUnitsStocked() -> Array[StoredUnit]:
	return unitsStock

func registerHand() -> Dictionary:
	# Register units stocked
	var serialized_units: Array = []
	
	for unit in unitsStock:
		serialized_units.append(unit.saveStoredUnit())
	
	var handData := {
		"cards": cards, 
		"cardsPlayed": cardsPlayed,
		"maxSize": maxSize,
		"units": serialized_units 
	}
	return handData

static func recoverHand(data: Dictionary, player: AbstractPlayer) -> void :
	var hand: PlayerHand = PlayerHand.new(player)
	hand.cards.assign(data["cards"])
	hand.cardsPlayed.assign(data["cardsPlayed"])
	hand.maxSize = data.maxSize
	# Recover stocked units data
	if data.get("units"):
		hand.unitsStock = []
		
		for unit_data in data["units"]:
			var stored_unit = StoredUnit.loadStoredUnit(unit_data)
			if stored_unit:
				hand.unitsStock.append(stored_unit)
	if data["units"] : hand.unitsStock.assign(data["units"])
	player.hand = hand
	#return hand No need to return the hand
