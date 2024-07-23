@tool
extends Node

class_name Carac

@onready var stats = $Stats
@onready var Capacités = $"Capacités"

@export var starting_stats = Resource

func _ready() -> void:
	stats.initialize(starting_stats)
	print(stats.get_P())
