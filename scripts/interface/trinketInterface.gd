## Correspond to a trinket displayed on player interface
class_name trinketInterface extends MarginContainer

var id: String 	#Id of the trinket
var state_tween: Tween # Allow to animate the trinket when it's active or disabled

func _ready() -> void:
	%Preview.visible = false

## Set the trinket label and texture
func setTrinket(trinket: AbstractTrinket) -> void :
	self.id = trinket.id
	%Preview.text = getPreviewText(trinket)
	%SpriteTrinket.texture = load(trinket.imgPath+"(32x32).png")
	
	trinket.trinket_state_changed.connect(update_visuals)
	update_visuals(trinket.isActive, trinket.isDisable)

## Update visuals of the trinket when it's disabled or used
func update_visuals(is_active: bool, is_disable: bool) -> void:
	if state_tween:
		state_tween.kill()
		
	if is_disable:
		%SpriteTrinket.self_modulate = Color(0.4, 0.4, 0.4, 0.5)
	elif is_active:
		%SpriteTrinket.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		state_tween = create_tween().set_loops()
		state_tween.tween_property(%SpriteTrinket, "self_modulate", Color(1.5, 1.5, 1.5, 1.0), 0.5)
		state_tween.tween_property(%SpriteTrinket, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)
	else:
		%SpriteTrinket.self_modulate = Color(1.0, 1.0, 1.0, 1.0)


func getPreviewText(trinket: AbstractTrinket) -> String :
	var finalText : String = ""
	for t: String in trinket.previewTrinket.split("!"):
		match t:
			"VA":
				finalText += str(trinket.value_A)
			"VB":
				finalText += str(trinket.value_B)
			"VC":
				finalText += str(trinket.value_C)
			"C":
				finalText += str(trinket.counter)
			"C2":
				finalText += str(trinket.counter2)
			_:
				finalText += t
	return finalText

## When the mouse entered the trinket illustration, we show a preview of effect
func _on_sprite_trinket_mouse_entered() -> void:
	%Preview.visible = true

func _on_sprite_trinket_mouse_exited():
	%Preview.visible = false
