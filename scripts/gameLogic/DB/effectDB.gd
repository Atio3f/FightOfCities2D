extends Node


const EFFECTS := {
	## UNITS EFFECTS
	# MONKEYS
	"set1:MonkeyEffect": preload("res://Ressources/effects/unitEffects/monkeys/MonkeyEffect.gd"),
	"set1:BerserkerBullEffect":  preload("res://Ressources/effects/unitEffects/bulls/BerserkerBullEffect.gd"),
	"set1:KnightMonkeyEffect": preload("res://Ressources/effects/unitEffects/monkeys/KnightMonkeyEffect.gd"),	
	"set1:GodMonkeySpeedEffect": preload("res://Ressources/effects/unitEffects/monkeys/GodMonkeySpeedEffect.gd"),
	"set1:GodMonkeyMinionEffect": preload("res://Ressources/effects/unitEffects/monkeys/GodMonkeyMinionEffect.gd"),
	"set1:QueenMonkey": preload("res://Ressources/effects/unitEffects/monkeys/QueenMonkeyEffect.gd"),
	"set1:OrangutanEffect": preload("res://Ressources/effects/unitEffects/monkeys/OrangutanEffect.gd"),	
	# MAGICAL BEASTS
	"set1:TemporalSnailKillEffect": preload("res://Ressources/effects/unitEffects/magicalBeasts/TemporalSnailKillEffect.gd"),
	"set1:TemporalSnailResurrectEffect": preload("res://Ressources/effects/unitEffects/magicalBeasts/TemporalSnailResurrectEffect.gd"),
	"set1:CADOEffect": preload("res://Ressources/effects/unitEffects/magicalBeasts/CADOEffect.gd"),
	"set1:StarvingShadowEffect": preload("res://Ressources/effects/unitEffects/magicalBeasts/StarvingShadowEffect.gd"),
	"set1:AtlasLionEffect": preload("res://Ressources/effects/unitEffects/magicalBeasts/AtlasLionEffect.gd"),
	## UPGRADE EFFECTS
	"UpgradeTestEffect": preload("res://Ressources/effects/permanentUpgradesEffects/UpgradeTestEffect.gd"),
	"UpgradePromotionEffect": preload("res://Ressources/effects/permanentUpgradesEffects/UpgradePromotionEffect.gd"),
	"UpgradeScoutEffect": preload("res://Ressources/effects/permanentUpgradesEffects/UpgradeScoutEffect.gd"),
	"UpgradeBloodyEffect": preload("res://Ressources/effects/permanentUpgradesEffects/UpgradeBloodyEffect.gd"),
	"UpgradeAgilityEffect": preload("res://Ressources/effects/permanentUpgradesEffects/UpgradeAgilityEffect.gd"),
	"UpgradeGlassCanonEffect": preload("res://Ressources/effects/permanentUpgradesEffects/UpgradeGlassCanonEffect.gd"),
	"UpgradeMultitaskingEffect": preload("res://Ressources/effects/permanentUpgradesEffects/UpgradeMultitaskingEffect.gd"),
	## KEYWORD EFFECTS
	"set1:RegenerationEffect": preload("res://Ressources/effects/RegenerationEffect.gd"),
	"set1:FreezeEffect": preload("res://Ressources/effects/keywordEffects/FreezeEffect.gd"),
	"set1:PoisonEffect": preload("res://Ressources/effects/keywordEffects/PoisonEffect.gd"),
	"set1:ThornsEffect": preload("res://Ressources/effects/keywordEffects/ThornsEffect.gd"),
	## ITEM EFFECTS
	"set1:WarAxeEffect": preload("res://Ressources/effects/itemEffects/bulls/WarAxeEffect.gd"),
	"set1:BouquetOfLiesEffect": preload("res://Ressources/effects/itemEffects/magicalBeasts/BouquetOfLiesEffect.gd"),
}

var effects_data: Dictionary = {}

func _ready():
	load_effects_from_file("res://translations/effect.json")

func load_effects_from_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		push_error("File not found : " + path)
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.parse_string(content)
	
	if json:
		effects_data = json
	else:
		push_error("Syntax error in effect json file")

func getEffectData(effect_id: String) -> Dictionary:
	if effects_data.has(effect_id):
		var effect_data : Dictionary = {}
		effect_data.assign(effects_data[effect_id])
		return effect_data
	else:
		push_error("Effect id not found : " + effect_id)
		return {}
