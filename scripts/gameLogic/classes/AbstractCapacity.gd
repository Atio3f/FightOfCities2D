extends Node
class_name AbstractCapacity

static var _uid_counter := 0
var id: String
var uid: String
var nameCapacity: String
var imgPath: String
var unitAssociated: AbstractUnit

var cooldown: int = 0 # 0 is capacity available
var currentCooldown: int = 0
var maxUses: int = -1
var usesRemaining: int = -1

enum TargetZone {
	CIRCULAR,
	EVERYWHERE,
	LINE
}

var targetRange: int = 1
var targetTypeZone: TargetZone = TargetZone.CIRCULAR

func _init(id: String, imgPath: String, unit: AbstractUnit, cooldown: int = 0, targetRange: int = 1, maxUses: int = -1):
	self.id = id
	_uid_counter += 1
	self.uid = str(randi() % 100000).pad_zeros(6) + str(Time.get_unix_time_from_system()) + str(_uid_counter)
	self.nameCapacity = id.substr(5) if id.length() > 5 else id
	self.imgPath = imgPath
	self.unitAssociated = unit
	self.cooldown = cooldown
	self.currentCooldown = 0
	self.maxUses = maxUses
	self.usesRemaining = maxUses
	self.targetRange = targetRange

## Return true if the capacity targets the whole map
func isGlobal() -> bool:
	return targetTypeZone == TargetZone.EVERYWHERE

## Get the list of cells that can be targeted by this capacity
func getTargetableCells(sourceTile: AbstractTile) -> Array[Vector2i]:
	if isGlobal():
		var cells: Array[Vector2i] = []
		cells.assign(MapManager.activeTiles.keys())
		return cells
	
	if unitAssociated != null and unitAssociated.player != null and unitAssociated.player.playerPointer != null:
		# Use the player pointer's flood_fill if range is standard
		return unitAssociated.player.playerPointer._flood_fill(sourceTile.getCoords(), targetRange)
	
	return []

## Main function to trigger the capacity on the valid targets
func onActivation(targetTile: AbstractTile, targetUnits: Array) -> void:
	pass

## Check if the activation is valid on this tile
func conditionActivation(targetTile: AbstractTile, targetUnits: Array) -> bool:
	return true

## Handle cooldown decreasing each turn
func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if turnColor == unitAssociated.team:
		if currentCooldown > 0:
			currentCooldown -= 1

func getDescription() -> String:
	if !Global.effectsStrings["en"].has(id) : return "DESCRIPTION NOT FOUND"
	return Global.effectsStrings["en"][id]["DESCRIPTION"]

func registerCapacity() -> Dictionary:
	return {
		"id": id,
		"uid": uid,
		"imgPath": imgPath,
		"nameCapacity": nameCapacity,
		"className": get_script().resource_path.get_file().get_basename(),
		"unitAssociatedId": unitAssociated.id if unitAssociated else "",
		"cooldown": cooldown,
		"currentCooldown": currentCooldown,
		"maxUses": maxUses,
		"usesRemaining": usesRemaining,
		"targetRange": targetRange,
		"targetTypeZone": targetTypeZone
	}

static func recoverCapacity(data: Dictionary, unit: AbstractUnit) -> AbstractCapacity:
	if data == {} : return null
	if CapacityDb.CAPACITIES.has(data.id):
		var capacity = CapacityDb.CAPACITIES[data.id].new(unit)
		capacity.uid = data.uid
		capacity.currentCooldown = data.currentCooldown
		capacity.usesRemaining = data.usesRemaining
		capacity.targetRange = data.targetRange
		capacity.targetTypeZone = data.targetTypeZone
		return capacity
	else :
		push_error("CAPACITY CLASS NOT FIND " + data.className)
		return null
