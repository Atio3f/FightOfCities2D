extends Node


const TILES = {
	"test:ForestTile" : preload("res://elements/tiles/ForestTile.gd"),
	"test:SakuraForestTile" : preload("res://elements/tiles/SakuraForestTile.gd"),
	"test:SwampTile" : preload("res://elements/tiles/SwampTile.gd"),
	"test:MountainTile" : preload("res://elements/tiles/MountainTile.gd"),
	"test:PlainTile" : preload("res://elements/tiles/PlainTile.gd"),
	"test:SnowPlainTile" : preload("res://elements/tiles/SnowPlainTile.gd"),
	"test:LakeTile" : preload("res://elements/tiles/LakeTile.gd"),
	"test:DesertTile" : preload("res://elements/tiles/DesertTile.gd"),
	"test:DeepWaterTile" : preload("res://elements/tiles/DeepWaterTile.gd"),
	"test:TropicalForestTile" : preload("res://elements/tiles/TropicalForestTile.gd"),
}

#Pour récup du tileset
#const TILES_NAME = {
	#"test:ForestTile" : "forest",
	#"test:SakuraForestTile" : "forest",	#A CHANGER QUAND ON AURA MIS DANS LE TILESET
	#"test:SwampTile" : "swamp",
	#"test:SnowPlainTile" : "snowPlain",
	#"test:PlainTile" : "plain",
	#"test:MountainTile" : "mountain",
	#"test:LakeTile" : "lake",
	#"test:DesertTile" : "desert"
#}
const TILES_VECTORS = {
	"test:PlainTile" : Vector2i(0, 0),
	"test:LakeTile" : Vector2i(0, 1),
	"test:SwampTile" : Vector2i(1, 0),
	"test:MountainTile" : Vector2i(1, 1),
	"test:SnowPlainTile" : Vector2i(2, 0),
	"test:ForestTile" : Vector2i(2, 1),
	"test:SakuraForestTile" : Vector2i(3, 0),
	"test:DesertTile" : Vector2i(3, 1),
	"test:DeepWaterTile" : Vector2i(4, 0),
	"test:TropicalForestTile" : Vector2i(4, 1)
}
