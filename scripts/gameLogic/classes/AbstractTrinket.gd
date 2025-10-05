class_name AbstractTrinket extends Node

var id: String
var nameTrinket: String
var imgPath: String
var playerAssociated: AbstractPlayer	#Forcément le joueur principal en soit

var rarity: Rarities.raritiesTrinkets

#3 values like effects to keep parameters for trinkets
var value_A: int
var value_B: int
var value_C: int 
var counter: int #Can be used to increment a value, will be used to count turns
var counter2: int #Can be used to increment a value, will be used to increment a value

func initialize(id: String, imgPath: String, rarity: Rarities.raritiesTrinkets, player: AbstractPlayer, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0, counter2: int = 0) -> void:
	self.id = id
	self.imgPath = imgPath
	#INSERER IMAGE A PARTIR DU PATH ICI
	playerAssociated = player
	playerAssociated.trinkets.append(self)
	self.value_A = value_A
	self.value_B = value_B
	self.value_C = value_C
	self.counter = counter
	self.counter2 = counter2


##Function called when the player obtain the trinket, not called on recover data
func onGain() -> void :
	pass

#ça sera probablement pas un String mais un type de carte ou alors la carte générée
func onCardPlay(player: AbstractPlayer, card: String) -> void:
	pass

#If the trinket applies an effect to all units that we can't calculate here, like reduce movement cost
func onUnitPlace(unit: AbstractUnit) -> void:
	pass

##Activate when an unit is moving
func onMovement(unitMoving: AbstractUnit) -> void:
	pass

##Activate when an item is played,  unit can be null
func onItemUsed(player: AbstractPlayer, isMalus: bool, unit: AbstractUnit = null) -> void:
	pass

#Get final damage from attacks
func onDamageTaken(unitAttacking: AbstractUnit, unitAttacked: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	return damage

#Return final damage taken
func onDamageDealed(unitAttacking: AbstractUnit, unitAttacked: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	return damage

func onHeal(unitHealing: AbstractUnit, unitHealed: AbstractUnit, healValue: int) -> int :
	return healValue

func onHealed(unitHealing: AbstractUnit, unitHealed: AbstractUnit, healValue: int) -> int :
	return healValue

##Activate when an unit of the player killed an other
func onKill(unitKilling: AbstractUnit, unitKilled: AbstractUnit) -> void :
	pass

##Activate when an unit of the player dies from an other
func onDeath(unitKilling: AbstractUnit, unitKilled: AbstractUnit) -> void:
	pass


##Activate at the start of turn
func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	pass


func registerTrinket() -> Dictionary :
	return {
		"id": self.id,
		"value_A": self.value_A,
		"value_B": self.value_B,
		"value_C": self.value_C,
		"counter": self.counter,
		"counter2": self.counter2
	}

static func recoverTrinket(trinketData: Dictionary, player: AbstractPlayer) -> void :
	GameManager.addTrinket(player, trinketData["id"], trinketData)
