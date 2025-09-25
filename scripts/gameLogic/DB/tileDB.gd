extends Node


const TILES = {
	"set1:ForestTile" : preload("res://Ressources/tiles/ForestTile.gd"),
	"set1:SakuraForestTile" : preload("res://Ressources/tiles/SakuraForestTile.gd"),
	"set1:SwampTile" : preload("res://Ressources/tiles/SwampTile.gd"),
	"set1:MountainTile" : preload("res://Ressources/tiles/MountainTile.gd"),
	"set1:PlainTile" : preload("res://Ressources/tiles/PlainTile.gd"),
	"set1:SnowPlainTile" : preload("res://Ressources/tiles/SnowPlainTile.gd"),
	"set1:LakeTile" : preload("res://Ressources/tiles/LakeTile.gd"),
	"set1:DesertTile" : preload("res://Ressources/tiles/DesertTile.gd"),
	"set1:DeepWaterTile" : preload("res://Ressources/tiles/DeepWaterTile.gd"),
	"set1:TropicalForestTile" : preload("res://Ressources/tiles/TropicalForestTile.gd"),
}

#Pour récup du tileset
#const TILES_NAME = {
	#"set1:ForestTile" : "forest",
	#"set1:SakuraForestTile" : "forest",	#A CHANGER QUAND ON AURA MIS DANS LE TILESET
	#"set1:SwampTile" : "swamp",
	#"set1:SnowPlainTile" : "snowPlain",
	#"set1:PlainTile" : "plain",
	#"set1:MountainTile" : "mountain",
	#"set1:LakeTile" : "lake",
	#"set1:DesertTile" : "desert"
#}
const TILES_VECTORS = {
	"set1:PlainTile" : Vector2i(0, 0),
	"set1:LakeTile" : Vector2i(0, 1),
	"set1:SwampTile" : Vector2i(1, 0),
	"set1:MountainTile" : Vector2i(1, 1),
	"set1:SnowPlainTile" : Vector2i(2, 0),
	"set1:ForestTile" : Vector2i(2, 1),
	"set1:SakuraForestTile" : Vector2i(3, 0),
	"set1:DesertTile" : Vector2i(3, 1),
	"set1:DeepWaterTile" : Vector2i(4, 0),
	"set1:TropicalForestTile" : Vector2i(4, 1)
}
