extends Node
class_name AbstractEffect

static var _uid_counter := 0
var id: String
var uid: String
var nameEffect: String
var imgEffect: Sprite2D
var imgPath: String
var unitAssociated: AbstractUnit
var unitsStocked: Array[AbstractUnit] = []	#Can be used if the effect need to stock units affected or the source?
var unitsStockedUids: Array[String] = []	#Contains all ids of units stocked, used only on load and is not actualize after that
var effectAssociated: AbstractEffect = null	#Generaly use when this effect is a sub effect of an unit
var effectAssociatedUid: String = ""	#Contains id of effect stocked as parent if there are one
var remainingTurns: int = -1	#Indicate how many turn before the end of the effect. If the effect is permanent, this value is -1
var priority: int	#Serve to place the effect on the Array on the unit. Determine if the order when we iterate effects
var stackable: bool	#Allow to know if we can stack effects
var hideEffect: bool = false	#Allow to hide the effect on the info Interface when it doesn't really affect the unit itself
var isActivable: bool = false	#Determine if the ability is an activable ability
#3 values to assign values to the effect once  
var value_A: int
var value_B: int
var value_C: int 
var counter: int #Can be used to increment a value 
func _init(id: String, imgPath: String, unit: AbstractUnit, remainingTurns: int, priority: int, stackable: bool, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	self.id = id
	_uid_counter += 1
	self.uid = str(randi() % 100000).pad_zeros(6) + str(Time.get_unix_time_from_system()) + str(_uid_counter)
	self.nameEffect = id.substr(5)
	self.imgPath = imgPath
	#INSERER IMAGE A PARTIR DU PATH ICI
	self.unitAssociated = unit
	self.remainingTurns = remainingTurns
	self.priority = priority
	self.stackable = stackable
	self.value_A = value_A
	self.value_B = value_B
	self.value_C = value_C
	self.counter = counter

func mergeEffect(effectToMerge: AbstractEffect) -> void:
	value_A += effectToMerge.value_A
	value_B += effectToMerge.value_B
	value_C += effectToMerge.value_C
	counter += effectToMerge.counter
	
	if remainingTurns != -1 and effectToMerge.remainingTurns != -1:
		remainingTurns = remainingTurns + effectToMerge.remainingTurns

	onEffectApplied(false, effectToMerge)

func onPlacement(tile: AbstractTile) -> void:
	1

#First time is to use when we have stackable effects which can modify values
#Parameter oldEffect serve to calculate how much we need to add in some effects like powerplus
func onEffectApplied(firstTime: bool, oldEffect:AbstractEffect = null) -> void:
	1

func onEffectEnd() -> void:
	1

#Will probably replace onUnitPlace for final version 
func onCardPlay(player: AbstractPlayer) -> void:
	1

func onUnitPlace(unit: AbstractUnit) -> void:
	1

func onMovement() -> void:
	1

func onItemUsed(player: AbstractPlayer, isMalus: bool) -> void:
	1

#Return final damage taken, visualisation serves to avoid activating effects like damage on offender before a true attack 
func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	return damage

#Return final damage taken
func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	return damage

func onHeal(unitHealed: AbstractUnit, healValue: int) -> int :
	return healValue

func onHealed(unitHealing: AbstractUnit, healValue: int) -> int :
	return healValue

func onKill(unitKilled: AbstractUnit) -> void :
	1

func onDeath(unit: AbstractUnit) -> void:
	pass

func onLevelUp(level: int) -> void :
	1

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if remainingTurns != -1 && turnColor == unitAssociated.team : remainingTurns -= 1 # Only decreases remainingTurns on unitAssociated turn
	if remainingTurns == 0 : onEffectEnd()

func getDescription() -> String:
	if !Global.effectsStrings["en"].has(id) : return "DESCRIPTION NOT FOUND"
	var desc: String = Global.effectsStrings["en"][id]["DESCRIPTION"]
	var finalDesc : String = ""
	for t: String in desc.split("!"):
		match t:
			"VA":
				finalDesc += str(value_A)
			"VB":
				finalDesc += str(value_B)
			"VC":
				finalDesc += str(value_C)
			"C":
				finalDesc += str(counter)
			_:
				finalDesc += t
	return finalDesc

func registerEffect() -> Dictionary:
	var effectAssociatedUid: String
	if effectAssociated : 
		effectAssociatedUid = effectAssociated.uid
	else :
		effectAssociatedUid = ""
	return {
		"id": id,
		"uid": self.uid,
		"imgPath": imgPath,
		"nameEffect": nameEffect,
		"className": get_script().resource_path.get_file().get_basename(),
		"unitAssociatedId": unitAssociated.id,
		"unitsStockedUids": unitsStocked.map(func(u): return u.uid),
		"effectAssociatedUid": effectAssociatedUid,
		"remainingTurns": remainingTurns,
		"priority": priority,
		"stackable": stackable,
		"hideEffect": hideEffect,
		"isActivable": isActivable,
		"value_A": value_A,
		"value_B": value_B,
		"value_C": value_C,
		"counter": counter
	}

static func recoverEffect(data: Dictionary, unit: AbstractUnit) -> AbstractEffect :
	#Create a effect with all elements associated
	if EffectDb.EFFECTS.has(data.className):
		var effect = EffectDb.EFFECTS[data.id].new(unit, data.remainingTurns, data.value_A, data.value_B, data.value_C, data.counter)
		effect.stackable = data.stackable #Normalement fait tout seul
		effect.uid = data.uid
		if data.effectAssociated != null:
			effect.effectAssociatedUid = data.effectAssociated
		#Rajouter le unitsStocked et faudra que ça stocke les uid du coup
		if data.unitsStockedUids != null :
			effect.unitsStockedUids = data.unitsStockedUids
		return effect
	else :
		push_error("EFFECT CLASS NOT FIND " + data.className)
		return null#Maybe create a unit via ?

## unitsList is a dictionary with uid of unit as key and an AbstractUnit as value to add it
func recoverUnitsStocked(unitsList: Dictionary, effectsList: Dictionary) -> void :
	for uid: String in unitsStockedUids:
		unitsStocked.append(unitsList[uid])
	if effectAssociatedUid != null && effectAssociatedUid != "" : 
		effectAssociated = effectsList[effectAssociatedUid]
