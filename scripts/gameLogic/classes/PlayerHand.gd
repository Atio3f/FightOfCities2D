extends Node
class_name PlayerHand
#Contains all cards that the player have in his inventory

var cards: Array[String] = []#Contains all id cards
var player: AbstractPlayer
var cardsPlayed: Array[String] = []
var maxSize: int = 10	#Nombre de cartes dans la main possible, inutilisé pour le moment
var unitsStock: Array[String] = []
func _init(playerAssociated: AbstractPlayer):
	self.player = playerAssociated

#Add a card to hand
func addCard(idCard: String) -> void:
	cards.append(idCard)

#Add a unit on your stock
func addUnitCard(idCard: String) -> void:
	unitsStock.append(idCard)

#Remove the card from the hand if the card can be played
func useCard(idCard: String) -> void:
	cards.erase(idCard)
	cardsPlayed.append(idCard)

func getHand() -> Array[String]:
	return cards

func getUnitsStocked() -> Array[String]:
	return unitsStock

func registerHand() -> Dictionary:
	var handData := {
		"cards": cards, 
		"cardsPlayed": cardsPlayed,
		"maxSize": maxSize,
		"units": unitsStock 
	}
	return handData

static func recoverHand(data: Dictionary, player: AbstractPlayer) -> void :
	var hand: PlayerHand = PlayerHand.new(player)
	hand.cards.assign(data["cards"])
	hand.cardsPlayed.assign(data["cardsPlayed"])
	hand.maxSize = data.maxSize
	if data["units"] : hand.unitsStock.assign(data["units"])
	player.hand = hand
	#return hand No need to return the hand
