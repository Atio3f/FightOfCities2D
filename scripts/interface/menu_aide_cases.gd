## Help Menu for terrain tiles cost and effects
extends MarginContainer
class_name MenuAideCases

signal back_pressed

@onready var tile_title_label = %TileTitleLabel
@onready var tile_icon_rect = %TileIconRect
@onready var tile_costs_label = %TileCostsLabel
@onready var tile_effects_separator = %TileEffectsSeparator
@onready var tile_effects_label = %TileEffectsLabel
@onready var back_btn = %BackButton
@onready var tile_list = %TileList

func _ready():
	back_btn.pressed.connect(func(): emit_signal("back_pressed"))
	
	# Preload TileSet for images
	var terrain_scene = preload("res://nodes/tilemaps/terrain512x512.tscn")
	var terrain_instance = terrain_scene.instantiate()
	var tileset: TileSet = terrain_instance.tile_set
	terrain_instance.queue_free()
	
	# Populate list
	for tile_id in TileDb.TILES:
		var btn = Button.new()
		var tile_script = TileDb.TILES[tile_id]
		var tile_instance = tile_script.new(0, 0)
		
		# Generate a name from ID (e.g., "set1:ForestTile" -> "ForestTile")
		var tile_name = tile_id.split(":")[1]
		btn.text = tr("TILE_" + tile_name.to_upper())
		btn.custom_minimum_size = Vector2(0, 60)
		
		btn.mouse_entered.connect(func(): _on_tile_hovered(tile_name, tile_instance, tile_id, tileset))
		
		tile_list.add_child(btn)

func _on_tile_hovered(tile_name: String, tile: AbstractTile, tile_id: String, tileset: TileSet):
	tile_title_label.text = tr("TILE_" + tile_name.to_upper())
	
	# Set Texture using TileSet atlas
	if TileDb.TILES_VECTORS.has(tile_id) and tileset != null:
		var coords = TileDb.TILES_VECTORS[tile_id]
		var source = tileset.get_source(0)
		if source is TileSetAtlasSource:
			var atlas_tex = AtlasTexture.new()
			atlas_tex.atlas = source.texture
			var region_size = source.texture_region_size
			atlas_tex.region = Rect2(coords * region_size, region_size)
			tile_icon_rect.texture = atlas_tex
	
	# Movement costs
	var walk_cost = tile.speedRequired.get(MovementTypes.movementTypes.WALK, 99)
	var fly_cost = tile.speedRequired.get(MovementTypes.movementTypes.FLYING, 99)
	var swim_cost = tile.speedRequired.get(MovementTypes.movementTypes.SWIMMING, 99)
	
	var cost_text = "[center][b]" + tr("HELP_TILE_COSTS") + "[/b]\n"
	cost_text += tr("MOVE_WALK") + " : " + str(walk_cost) + "\n"
	cost_text += tr("MOVE_FLY") + " : " + str(fly_cost) + "\n"
	cost_text += tr("MOVE_SWIM") + " : " + str(swim_cost) + "[/center]"
	tile_costs_label.text = cost_text
	
	# Effects
	var desc_text = tr("TILE_DESC_" + tile_name.to_upper())
	if not desc_text.begins_with("TILE_DESC_"):
		tile_effects_separator.visible = true
		tile_effects_label.visible = true
		
		var effects_text = "[center][b]" + tr("HELP_TILE_EFFECTS") + "[/b]\n"
		effects_text += desc_text + "[/center]"
		tile_effects_label.text = effects_text
	else:
		tile_effects_separator.visible = false
		tile_effects_label.visible = false
