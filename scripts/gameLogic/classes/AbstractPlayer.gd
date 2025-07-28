extends Node
class_name AbstractPlayer


var playerName: String 
var team: TeamsColor.TeamsColor #Team Color
var units: Array[AbstractUnit] = []
var orbs: int
var maxOrbs: int
const ORBS_BASE: int = 2
const MAX_ORBS_BASE: int = 5
var hand: PlayerHand

func _init(team: TeamsColor.TeamsColor, name: String):
	self.playerName = name
	self.team = team
	GameManager.players.append(self)
	orbs = ORBS_BASE
	maxOrbs = MAX_ORBS_BASE
	hand = PlayerHand.new(self)

func getUnits() -> Array[AbstractUnit]:
	return units

func getUnitsByTag(tag: Tags.tags) -> Array[AbstractUnit]:
	var _units : Array[AbstractUnit] = []
	for unit in units:
		if(unit.tags.has(tag) && !unit.isDead):
			_units.append(unit)
	return _units

func getCards() -> Array[String] :
	return hand.getHand()

#Renvoie les cartes jouables du joueur depuis son inventaire(pour le moment on compte pas 
#pê inutile et juste faire getCards et boucler cardCanBePlayedInventory pour toutes les cartes
func getUsableCardsInventory() -> Array[String] :
	return hand.getHand()

func cardCanBePlayedInventory(idCard: String) -> bool :
	return targetsAvailable(idCard) != []

#Peut contenir des unités ou des joueurs, pour ça que je précise pas dans le renvoi
func targetsAvailable(idCard: String) -> Array :
	var targets: Array = []
	#Iterate through units to get the list of targets availabled
	for unit: AbstractUnit in GameManager.getAllUnits():
		if ItemDb.ITEMS[idCard].canBeUsedOnUnit(self, unit) :
			targets.append(unit)

	for player: AbstractPlayer in GameManager.getPlayers():
		if ItemDb.ITEMS[idCard].canBeUsedOnPlayer(self, player) :
			targets.append(player)
	return targets

func cardPlayable(idCard: String) -> Array :
	if !hand.getHand().has(idCard) :
		return []
	return targetsAvailable(idCard)

#Sera appelé quand on clique sur une carte jouable
func useCard(idCard: String, targets: Array) -> void :
	for target in targets :
		#Permet d'envoyer des informations différentes en fonction de si la cible est une unité ou un joueur
		if target.getClass() == "AbstractUnit" : 
			ItemDb.ITEMS[idCard].new(target.player, target)
		elif target.getClass() == "AbstractPlayer": 
			ItemDb.ITEMS[idCard].new(target, null)
	hand.useCard(idCard)

#Pour ajouter une carte à la main du joueur
func addCard(idCard: String) -> void:
	hand.addCard(idCard)

#We can't override get_class method from Node sadly
func getClass() -> String :
	return "AbstractPlayer"

func registerPlayer() -> Dictionary :
	var playerData := {
		"playerName": self.playerName,
		"team": self.team,
		"orbs": self.orbs,
		"maxOrbs": self.maxOrbs,
		"units": []  # Une liste d'unités
	}
	for unit: AbstractUnit in units:
		playerData["units"].append(unit.registerUnit())
	return playerData


static func recoverPlayer(data: Dictionary) -> AbstractPlayer :
	var player = AbstractPlayer.new(data.team, data.playerName)
	player.orbs = data.orbs
	player.maxOrbs = data.maxOrbs
	for unitData in data.units:
		player.units.append(AbstractUnit.recoverUnit(unitData, player))
	return player
