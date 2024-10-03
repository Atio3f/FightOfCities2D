## Represents and manages the game board. Stores references to entities that are in each cell and
## tells whether cells are occupied or not.
## Units can only move around the grid one at a time.
class_name GameBoard
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
const OBSTACLE_ATLAS_ID = 2

## Resource of type Grid.
@export var grid: Resource

## Mapping of coordinates of a cell to a reference to the unit it contains.
#var _units := {}
#var _active_unit: unite		#_active_unit a été remplacé par pointeurSelec.Selection
var _walkable_cells := {}
var _attackable_cells := []
var _movement_costs

@onready var visuActions: UnitOverlay = $visualisationActions
@onready var _unit_path: UnitPath = $UnitPath
@onready var terrain: TileMap = $Terrain32x32
#@onready var pointeurSelec : Node2D = $"../Player/Pointeur_Selection"

const MAX_VALUE: int = 99999



