extends Path2D
class_name AbstractUnit
#Represent a unit
static var _uid_counter := 0
static var xpPerLevel = [0, 90, 220, 400, 700, 99999]
var id: String	#Id of the unit, serve to know the id of the unit
var uid: String	#Identifiant unique créer lorsqu'on place l'unité
var imgPath: String
var grade: int
var hpActual: int
var hpMax: int
var hpBase: int
var hpTemp: int
#Manque pê encore certains trucs sur les pv
var power: int
var powerBase: int #Base value of p for the unit without any bonus or change
var damageType: DamageTypes.DamageTypes
var atkPerTurn: int = 1; #Number of attacks the unit can perform each turn
var atkRemaining: int
var atkPerTurnBase: int
var range: int
var speed: int
var speedRemaining: int	#Speed remaining for this turn
var speedBase: int #Base value of speed for the unit without any bonus or change
var dr: int	#1 point of damage resistance (against physical attacks?) = 1 less damage taken each (physical?)attack
var drBase: int #Base value of damage reduction for the unit without any bonus or change
var mr: int	#1 point of magical resistance (against magic attacks) = 1 less damage taken each magic attack
var mrBase: int #Base value of damage reduction for the unit without any bonus or change
var potential: int #VALEUR DE 2 A 5 qui définit le niveau maximal atteignable par une unité, ne peut pas être modifié normalement 
var wisdom: int	#METTRE DESC J'AI OUBLIE MDR mais c'est wisdom en tout cas
var wisdomBase: int #Base value of wisdom for the unit without any bonus or change

var level: int	#Current level
var xp: int		#Current xp

var player: AbstractPlayer
var team: TeamsColor.TeamsColor #Team Color, get from player you control him
var effects: Array[AbstractEffect] = []
var equipments: Array[AbstractEquipment] = []
var equipmentLimit: int = 3	#Global limit on the number of equipments that an unit can have, some units will have a worse or better limit
var tags: Array[Tags.tags] = []
var tile: AbstractTile	#Keep the tile where is the unit
var isDead: bool	#Allow us to keep track of units killed

@onready var contourSelec : Sprite2D = $UnitElements/ContourSelection
var is_selected : bool = false:
	set(value):
		if(value == true):
			contourSelec.visible = true
		else:
			contourSelec.visible = false
		is_selected = value
var _is_walking := false:
	set(value):
		_is_walking = value
		set_process(_is_walking)
		
signal signalFinMouvement
## Designate the current unit in a "wait" state
@export var is_wait := false

#CHECK SI ILS SERVENT
@onready var _path_follow: PathFollow2D = $UnitElements
@onready var sprite : Sprite2D = $UnitElements/UnitSprite
@onready var interfaceUnite : interfaceUnite = $UnitElements/InterfaceUnite	#La barre de vie affichée est changée lorsque l'unité perd ou gagne des pv ou pv max
@onready var noeudsTempIndic : Node2D = $NoeudsTemp/IndicDegats	#Sert au stockage de tous les noeuds qui disparaissent(ex  popUpDegats)

 
var movementTypes : Array[MovementTypes.movementTypes] = []
var actualMovementTypes : MovementTypes.movementTypes = MovementTypes.movementTypes.NONE


var case : Vector2i = Vector2i.ZERO	#TEST A CHAGER SI CA MARCHE TJRS PAS LE MOUVEMENT UNITE

func _ready():
	set_process(true)
	_path_follow.rotates = false
	position = Vector2.ZERO
	if not Engine.is_editor_hint():
		curve = Curve2D.new()

func initializeStats(id: String, imgPath: String, playerAssociated: AbstractPlayer, grade: int, hpBase: int, powerBase:int, damageType: DamageTypes.DamageTypes, atkPerTurnBase: int, range: int, speedBase: int, drBase: int, mrBase: int, potential: int, wisdomBase: int, idDead: bool = false):
	self.id = id
	_uid_counter += 1
	self.uid = str(randi() % 100000).pad_zeros(6) + str(Time.get_unix_time_from_system()) + str(_uid_counter)
	#Add img and refresh the sprite
	self.imgPath = imgPath
	refreshSprite()
	self.player = playerAssociated
	self.team = playerAssociated.team
	self.grade = grade
	self.hpActual = hpBase
	self.hpMax = hpBase
	self.hpBase = hpBase
	self.hpTemp = 0
	self.power = powerBase
	self.powerBase = powerBase
	self.atkPerTurn = atkPerTurnBase
	self.atkRemaining = 0
	self.atkPerTurnBase = atkPerTurnBase
	self.range = range
	self.speed = speedBase
	self.speedRemaining = 0
	self.speedBase = speedBase
	self.drBase = drBase
	self.dr = drBase
	self.mr = mrBase
	self.mrBase = mrBase
	self.potential = potential
	self.wisdom = wisdomBase
	self.wisdomBase = wisdomBase
	self.damageType = damageType
	self.isDead = isDead
	playerAssociated.units.append(self)

func initStats(uid: String, hpMax: int, hpActual: int, hpTemp: int, power: int, speed: int, speedRemaining: int, atkPerTurn: int, atkRemaining: int, dr: int, mr: int, wisdom: int, level: int):
	self.uid = uid
	self.hpMax = hpMax
	self.hpActual = hpActual
	self.hpTemp = hpTemp
	self.power = power
	self.speed = speed
	self.speedRemaining = speedRemaining
	self.atkPerTurn = atkPerTurn
	self.atkRemaining = atkRemaining
	self.dr = dr
	self.mr = mr
	self.wisdom = wisdom
	self.level = level

### MOVEMENT PART OF THE SPRITE
func _process(delta: float) -> void:
	_path_follow.progress += 10 * MapManager.cellSize * delta
	if _path_follow.progress_ratio >= 1.0:
		_is_walking = false
		# Setting this value to 0.0 causes a Zero Length Interval error
		_path_follow.progress = 0.00001
		position = MapManager.calculate_map_position(tile.getCoords())
		curve.clear_points()
		emit_signal("signalFinMouvement")

func deplacement(newTile: AbstractTile) -> void:
	self.onMovement(newTile)
	#position = MapManager.calculate_map_position(newTile.getCoords())#Work but looks like tp sadly

## Starts walking along the `path`.
## `path` is an array of grid coordinates that the function converts to map coordinates.
func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(MapManager.calculate_map_position(point) - position)
	
	#case = path[-1] #J'ARRIVE PAS A COMPRENDRE A QUOI ça SERT DE NOTER LA NOUVELLE CASE
	_is_walking = true
	
#Fonction qui s'active lorsque l'unité est sélectionnée
func selectionneSelf(pointeurJoueurI : pointeurJoueur, menuOpen : bool):
	if(menuOpen):	#On n'affiche le menu que lorsque le pointeur du joueur que lorsqu'on fait un click droit
		interfaceUnite.apercuMenusUnite(self, pointeurJoueurI, true)
	is_selected = true
	
	
#Cache le menu dans l'interface de l'unité et seslorsque l'unité est déselectionnée
func deselectionneSelf(pointeurJoueurI : pointeurJoueur):
	
	interfaceUnite.apercuMenusUnite(self, pointeurJoueurI, false)
	is_selected = false
	

func getPlayer() -> AbstractPlayer:
	return player

func getPower() -> int:
	return power

#Add an effect to the unit. If the unit already have the effect, it's incremented. 
#Maybe it needs to be optimized to stop the for when we pass the priority place
func addEffect(effect: AbstractEffect) -> void:
	var rank: int = 0
	var inserted: bool = false
	for _effect: AbstractEffect in effects :
		if(_effect.id == effect.id):
			if(!_effect.stackable):
				effects.insert(rank + 1, effect)
				effect.onEffectApplied(true)
			else:
				_effect.mergeEffect(effect)
			inserted = true
			break
		elif(_effect.priority > effect.priority):
			 #place effect in
			effects.insert(rank, effect)
			effect.onEffectApplied(true)
			inserted = true
			break
		rank += 1
	
	if(!inserted):
		effects.append(effect)
		effect.onEffectApplied(true)

#Maybe we will change the type of tile and register it
func onPlacement(tile: AbstractTile) -> void:
	self.tile = tile
	self.position = MapManager.calculate_map_position(tile.getCoords())
	print("onPlacement : "+ str(tile.getCoords()) + " COORDS FINALES:" + str(tile.getCoords() * MapManager.cellSize + Vector2i(MapManager._half_cell_size, MapManager._half_cell_size)))
	GameManager.whenUnitPlace(self)
	for effect: AbstractEffect in effects:
		effect.onPlacement(tile)
	tile.onUnitIn(self)

func onCardPlay(player: AbstractPlayer) -> void:
	for effect: AbstractEffect in effects:
		effect.onCardPlay(player)

func onUnitPlace(unit: AbstractUnit) -> void:
	for effect: AbstractEffect in effects:
		effect.onUnitPlace(unit)

#Tile is the actual tile after the movement
func onMovement(tile: AbstractTile) -> void:
	#Remove the unit from the tile he was
	self.tile.onUnitOut()
	self.tile = tile
	#Place the unit on its new tile
	tile.onUnitIn(self)
	for effect: AbstractEffect in effects:
		effect.onMovement()
	for trinket: AbstractTrinket in player.trinkets :
		trinket.onMovement(self)

#J'ai retiré item: AbstractItem,  comme param parce que pour le moment ça sert à r
func onItemUsed(player: AbstractPlayer, isMalus: bool) -> void:
	for effect: AbstractEffect in effects:
		effect.onItemUsed(player, isMalus)

#Return final damage taken, visualisation serve if we need to see damage dealed before the action
func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> Dictionary :#DamageType is an int because Gdscript is badly make and we can't place a enum which isn't the first on its file
	var damageReduction : int
	match damageType:
		DamageTypes.DamageTypes.PHYSICAL:
			damageReduction = dr
		DamageTypes.DamageTypes.MAGICAL:
			damageReduction = mr
		_:
			damageReduction = 0
	damage = 0 if (damageReduction > damage) else (damage - damageReduction)
	for effect: AbstractEffect in effects:
		damage = effect.onDamageTaken(unit, damage, damageType, visualisation)
	for trinket: AbstractTrinket in player.trinkets :
		damage = trinket.onDamageTaken(unit, self, damage, damageType, visualisation)
	var hpLoses: Dictionary
	#If it's not a true attack we just return value
	if(!visualisation):
		hpLoses = loseHp(damage)
		##Damage Indicator
		var indicDegats : damageIndicator = Global.popUpDegats.instantiate()	
		noeudsTempIndic.add_child(indicDegats)		#Place l'indicateur de dégâts sur la scène
		indicDegats.newPopUp(damage)
		
	else :
		hpLoses = getLoseHp(damage)
	return hpLoses

#Return final damage taken
func onDamageDealed(unit: AbstractUnit, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	var damage: int = getPower()
	for effect: AbstractEffect in effects:
		damage = effect.onDamageDealed(unit, damage, damageType, visualisation)
	for trinket: AbstractTrinket in player.trinkets :
		damage = trinket.onDamageDealed(self, unit, damage, damageType, visualisation)
	return damage

func loseHp(damage: int) -> Dictionary:
	var hpLoses: Dictionary = getLoseHp(damage)
	hpTemp = hpLoses["hpTemp"]
	hpActual = hpLoses["hpActual"]
	return hpLoses

func getLoseHp(damage: int) -> Dictionary:
	var hpLoses: Dictionary = {}
	hpLoses["damage"] = damage
	if damage < hpTemp :
		hpLoses["hpTemp"] = hpTemp - damage
		hpLoses["hpActual"] = hpActual
	else: 
		damage -= hpTemp
		hpLoses["hpTemp"] = 0
		hpLoses["hpActual"] = (hpActual - damage) if (hpActual > damage) else 0
	return hpLoses

func onHeal(unitHealed: AbstractUnit, healValue: int) -> int :
	for effect: AbstractEffect in effects:
		healValue = effect.onHeal(unitHealed, healValue)
	for trinket: AbstractTrinket in player.trinkets:
		healValue = trinket.onHeal(self, unitHealed, healValue)
	return healValue

func onHealed(unitHealing: AbstractUnit, healValue: int) -> int :
	for effect: AbstractEffect in effects:
		healValue = effect.onHealed(unitHealing, healValue)
	for trinket: AbstractTrinket in player.trinkets:
		healValue = trinket.onHealed(unitHealing, self, healValue)
	return healValue

func healHp(healValue: int):
	if(hpActual + healValue > hpMax):
		hpActual = hpMax
	else:
		hpActual += healValue

func onKill(unitKilled: AbstractUnit) -> void :
	#gainXp(ActionTypes.actionTypes.KILL, {"maxHp":unitKilled.hpMax})
	for effect: AbstractEffect in effects:
		effect.onKill(unitKilled)
	for trinket: AbstractTrinket in player.trinkets:
		trinket.onKill(self, unitKilled)

func onDeath(unit: AbstractUnit = null) -> void:
	for effect: AbstractEffect in effects:
		effect.onDeath(unit)
	for trinket: AbstractTrinket in player.trinkets:
		trinket.onDeath(unit, self)
	isDead = true	#You're not supposed to be able to survive once you're in this function
	removeSelf()

##Remove the unit from active units and its tile and hide it, will be called by onDeath method and the delete button on interface
func removeSelf() -> void:
	player.removeUnit(self)
	tile.unitOn = null	#Free the tile
	queue_free()

#func onLevelUp() -> void :
	#for effect: AbstractEffect in effects:
		#effect.onLevelUp(level)
	#calculateLevel()#Allow to gain multiple levels if you got enough xp

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if(turnColor == self.team):
		print("OUR TURN")
		speedRemaining = speed
		atkRemaining = atkPerTurn
		tile.onStartOfTurn(self)
	#Est-ce qu'on bloquerait pas ça à seulement le tour du joueur avec le if?
	for effect: AbstractEffect in effects:
		effect.onStartOfTurn(turnNumber, turnColor)

#Manage all cases where an unit gain xp
#func gainXp(action: ActionTypes.actionTypes, infos: Dictionary = {})-> void:
	#match action:
		#ActionTypes.actionTypes.ATTACK:
			#xp = xp + (infos.damage * 0.75 + wisdom)
		#ActionTypes.actionTypes.ATTACKED:
			#xp = xp + ((infos.damage + wisdom) /2)
		#ActionTypes.actionTypes.KILL:
			#xp = xp + infos.maxHp + (2 * wisdom)
		#_:
			#1
	#calculateLevel()

#func calculateLevel() -> void :
	#if level == potential : return	#Already level max
	#if xpPerLevel[level] < xp :
		#level += 1	#Set the new level
		##Reajust the stats depending of the new level reached
		#match level:
			#2:
				#hpMax += hpBase / 2
				#hpActual += hpBase / 2
				#power += 3
				#dr += 1
				#mr += 1
				#speed += 2
				#wisdom += 1
			#3:
				#hpMax += hpBase / 2
				#hpActual += hpBase / 2
				#power += powerBase / 2 + 1
				#dr += 3
				#mr += 3
				#speed += 2
				#wisdom += 2
			#4:
				#hpMax += hpBase / 2
				#hpActual += hpBase / 2
				#atkPerTurn += 1
				#atkRemaining += 1
				#power += powerBase / 2
				#dr += 4
				#mr += 4
				#speed += 3
				#speedRemaining += 3
				#wisdom += 3
			#5:
				#hpMax += hpBase
				#hpActual += hpBase
				#power += powerBase + 1
				#dr += drBase + 5
				#mr += mrBase + 5
				#speed += 3
				#speedRemaining += 3
				#wisdom += 5
		#onLevelUp()
	#else:
		#return

##Check if an equipment can be equip on this unit
func canEquipEquipment(equipment: AbstractEquipment) -> bool :
	if equipmentLimit == equipments.size() : return false
	if equipment.equipmentType >= 10 : return true	#EquipmentType >= 10 are others which can have multiple equiped at the same time
	for _equipment : AbstractEquipment in equipments:
		if _equipment.equipmentType == equipment.equipmentType :
			return false
	return true	#If no equipment on unit have the same type and unit still have place, we can equip it

## Use to equip an equipment, need to use the method from AbstractPlayer which check if we can equip it (canEquipEquipment())
func equipEquipment(equipment: AbstractEquipment) -> void :
	equipments.append(equipment)

#We can't override get_class method from Node sadly
func getClass() -> String :
	return "AbstractUnit"

func getName() -> String :
	return UnitsStrings["en"][id]["NAME"]
	#return Global.getUnitsStrings()

func getImagePath() -> String :
	return "res://assets/sprites/units/"+imgPath

func refreshSprite() -> void :
	sprite.texture = load(getImagePath()+".png")

func registerUnit() -> Dictionary :
	var unitData := {
		"id": self.id,
		"imgPath": self.imgPath,
		"uid": self.uid,
		"className": get_script().resource_path.get_file().get_basename(),
		"grade": self.grade,
		"hpBase": self.hpBase,
		"hpMax": self.hpMax,
		"hpActual": self.hpActual,
		"hpTemp": self.hpTemp,
		"powerBase": self.powerBase,
		"power": self.power,
		"damageType": self.damageType,
		"atkPerTurn": self.atkPerTurn,
		"atkPerTurnBase": self.atkPerTurn,
		"atkRemaining": self.atkRemaining,
		"range": self.range,
		"speedBase": self.speedBase,
		"speed": self.speed,
		"speedRemaining": self.speedRemaining,
		"drBase": self.drBase,
		"dr": self.dr,
		"mrBase": self.mrBase,
		"mr": self.mr,
		"wisdomBase": self.wisdomBase,
		"wisdom": self.wisdom,
		"potential": self.potential,
		"level": self.level,
		"xp": self.xp,
		"tags": self.tags,
		"movementTypes": self.movementTypes,
		"actualMovementTypes": self.actualMovementTypes,
		"tile": self.tile,
		"isDead": self.isDead,
		"effects": []  # Une liste d'effets
	}
	for effect: AbstractEffect in effects:
		unitData["effects"].append(effect.registerEffect())
	return unitData
	
##Pareil que dans AbstractPlayer il faudra sûrement changer l'emplacement de cette fonction
#static func recoverUnit(data: Dictionary, player: AbstractPlayer) -> AbstractUnit :
	##Create a unit with all elements associated, need to add some things !!! like playerAssociated
	#if UnitDb.UNITS.has(data.className):
		##Pas faisable car pas même nbr de param + inutile
		##var unit = UnitDb.UNITS[data.className].new(data.id, player, data.hpBase, data.powerBase, data.atkPerTurnBase, data.range, data.speedBase, data.drBase, data.mrBase, data.potential, data.wisdomBase)
		#var unit = AbstractUnit.new(data.id, data.imgPath, player, data.grade, data.hpBase, data.powerBase, data.damageType, data.atkPerTurnBase, data.range, data.speedBase, data.drBase, data.mrBase, data.potential, data.wisdomBase)
		#unit.initStats(data.uid, data.hpMax, data.hpActual, data.hpTemp, data.power, data.speed, data.speedRemaining, data.atkPerTurn, data.atkRemaining, data.dr, data.mr, data.wisdom, data.level, data.xp)
		#unit.tile = data.tile
		#for tag: int in data.tags:
			#unit.tags.append(tag)
		#
		#for movementType: int in data.movementTypes:
			#unit.movementTypes.append(data.movementTypes)
		#unit.actualMovementTypes = data.actualMovementTypes
		#unit.isDead = data.isDead
		#for effectData in data.effects:
			#unit.effects.append(AbstractEffect.recoverEffect(effectData, unit))
		#return unit
	#else :
		#push_error("UNIT CLASS NOT FIND")
		#return null#Maybe create a unit via ?
	
	
