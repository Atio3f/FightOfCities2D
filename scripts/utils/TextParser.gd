## Add icons corresponding to keywords
class_name TextParser
extends RefCounted

const ICONS = {
	"[PARALYSIS]": "res://assets/sprites/icons/status/Paralysis.png",
	"[FREEZE]": "res://assets/sprites/icons/status/Freeze.png",
	"[POISON]": "res://assets/sprites/icons/status/Poison.png",
	#"[CURSE]": "res://assets/sprites/icons/status/Curse.png",
	#"[BURN]": "res://assets/sprites/icons/status/Burn.png",
	#"[BLEED]": "res://assets/sprites/icons/status/Bleed.png"
}

static func parse_icons(text: String) -> String:
	var parsed_text = text
	for tag in ICONS:
		parsed_text = parsed_text.replace(tag, "[img=24x24]" + ICONS[tag] + "[/img]")
	return parsed_text
