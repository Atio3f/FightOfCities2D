extends Node
class_name AbstractTile

var id: String
var speedRequired: Dictionary = {}	#Contains all speed costs for differents type of movement

#Gérer l'assignation dans GameManager
var x: int	#Coord x
var y: int	#Coord y
var priority: int	#indicate the order of the tile on its coordinates


func _init(id: String, walkSpeed: int, flySpeed: int, swimSpeed: int):
	self.id = id
	speedRequired[MovementTypes.movementTypes.WALK] = walkSpeed
	speedRequired[MovementTypes.movementTypes.FLYING] = flySpeed
	speedRequired[MovementTypes.movementTypes.SWIMMING] = swimSpeed

#Quand unité parcourt la case(pê inutile ou infaisable)


#Quand l'unité est sur la case
func onUnitIn(unit: AbstractUnit) -> void :
	return

#Quand unité est sur la case au début du tour
func onStartOfTurn(unit: AbstractUnit) -> void:
	return

#Quand unité quitte case
func onUnitOut(unit: AbstractUnit) -> void :
	return
