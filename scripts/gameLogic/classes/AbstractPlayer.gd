extends Node
class_name AbstractPlayer


var playerName: String 
var team: TeamsColor.TeamsColor #Team Color
var units: Array[AbstractUnit] = []
var orbs: int = ORBS_BASE
var maxOrbs: int = MAX_ORBS_BASE
const ORBS_BASE: int = 2
const MAX_ORBS_BASE: int = 5

var trinkets: Array[AbstractTrinket] = []


#Weight is the max place that your troups can take
const WEIGHT_BASE: int = 6
var weight: int
var maxWeight: int = WEIGHT_BASE
#Max units represent the maximum number of units of the player
const MAX_UNITS_BASE: int = 3	
var maxUnits: int = MAX_UNITS_BASE
var hand: PlayerHand
var activeCapacity	#capacité active actuelle
var isGamePlayer: bool = false	#Serve to know if the player is the one you control the game

var playerPointer: pointeurJoueur	#Will allow interfaces to access some functions on Pointeur_Selection, for main player only

func initialize(team: TeamsColor.TeamsColor, name: String, isGamePlayer: bool):
	self.playerName = name
	self.team = team
	self.isGamePlayer = isGamePlayer
	GameManager.players.append(self)
	hand = PlayerHand.new(self)
	if isGamePlayer : 
		$Actions.player = self
		fixCameraLimit(MapManager.length, MapManager.width)
		playerPointer = $Pointeur_Selection
	else : 
		pass#$Actions.player = self#Will contains the AI
	weight = 0

###Fix the limit of camera depending of terrain size & tile size
func fixCameraLimit(x: int, y: int) -> void:
	if !isGamePlayer : return
	%Movement.limitLeft = -7 * MapManager.cellSize - 500
	%Movement.limitRight = x * 1.4 * MapManager.cellSize + 80
	%Movement.limitUp = -6 *  MapManager.cellSize - 100
	%Movement.limitDown = y * 1.2 * MapManager.cellSize + 80


func getUnits() -> Array[AbstractUnit]:
	return units

func getUnitsByTag(tag: Tags.tags) -> Array[AbstractUnit]:
	var _units : Array[AbstractUnit] = []
	for unit in units:
		#If the unit have been deleted, we remove it from the list
		if unit == null : 
			units.erase(unit)
			continue
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

func removeUnit(unit: AbstractUnit) -> void:
	addWeight(-unit.grade) 
	units.erase(unit)

##Add max weight to the player
func addMaxWeight(amt: int) -> void:
	maxWeight += amt
	if $Actions :
		$Actions.interfaceFinTour.updateInterface()

##Add weight to the player, usually when an unit dies or is spawned
func addWeight(amt: int) -> void:
	if amt > 0 :
		if amt + weight > maxWeight : weight = maxWeight
		else : weight += amt
	else :
		if amt + weight < 0 : weight = 0
		else : weight += amt 
	if $Actions :
		$Actions.interfaceFinTour.updateInterface()

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

##Add a new unit to the player
#Will need a way to stock infos about each unit between battles, idk where
func addUnitCard(idCard: String) -> void:
	hand.addUnitCard(idCard)

##Use when gaining or losing orbs
func gainOrbs(amt: int) -> void:
	if amt > 0 :
		if amt + orbs > maxOrbs : orbs = maxOrbs
		else : orbs += amt
	else :
		if amt + orbs < 0 : orbs = 0
		else : orbs += amt

##To add an equipment to an unit
func addEquipment(idEquipment: String) -> void:
	if hand.cards.has(idEquipment) :
		#Check if the equipment can be equipped
		#Add equipment to unit
		pass

###Add the trinket to the interface
func setTrinket(trinket: AbstractTrinket) -> void :
	if isGamePlayer :
		var trinketIface: trinketInterface = Global.trinketInterface.instantiate() as trinketInterface
		%Trinkets.add_child(trinketIface)
		trinketIface.setTrinket(trinket)

#We can't override get_class method from Node sadly
func getClass() -> String :
	return "AbstractPlayer"

func registerPlayer() -> Dictionary :
	var playerData := {
		"playerName": self.playerName,
		"team": self.team,
		"orbs": self.orbs,
		"maxOrbs": self.maxOrbs,
		"weight": self.weight,
		"maxWeight": self.maxWeight,
		"units": []  # Une liste d'unités
	}
	for unit: AbstractUnit in units:
		playerData["units"].append(unit.registerUnit())
	return playerData

###Y'a un monde où il faudra le faire en dehors d'AbstractPlayer mtn
#static func recoverPlayer(data: Dictionary) -> AbstractPlayer :
	#var player = AbstractPlayer.new(data.team, data.playerName)
	#player.orbs = data.orbs
	#player.maxOrbs = data.maxOrbs
	#player.weight = data.weight
	#player.maxWeight = data.maxWeight
	#for unitData in data.units:
		#player.units.append(AbstractUnit.recoverUnit(unitData, player))
	#return player
