extends Node
class_name AbstractTile

var id: String
var speedRequired: Dictionary = {}	#Contains all speed costs for differents type of movement

#Gérer l'assignation dans GameManager
var x: int	#Coord x
var y: int	#Coord y
var priority: int	#indicate the order of the tile on its coordinates
var unitOn: AbstractUnit = null

func _init(id: String, walkSpeed: int, flySpeed: int, swimSpeed: int):
	self.id = id
	speedRequired[MovementTypes.movementTypes.WALK] = walkSpeed
	speedRequired[MovementTypes.movementTypes.FLYING] = flySpeed
	speedRequired[MovementTypes.movementTypes.SWIMMING] = swimSpeed

#Quand unité parcourt la case(pê inutile ou infaisable)


#Quand l'unité est sur la case
func onUnitIn(unit: AbstractUnit) -> void :
	unitOn = unit
	return

#Quand unité est sur la case au début du tour
func onStartOfTurn(unit: AbstractUnit) -> void:
	return

#Quand unité quitte case, y'avait unit: AbstractUnit comme param mais en vrai c'est stupide
func onUnitOut() -> void :
	unitOn = null
	return

func getCoords() -> Vector2i :
	return Vector2i(x, y)

##Return if there is an unit on this tile
func hasUnitOn() -> bool:
	return unitOn != null
