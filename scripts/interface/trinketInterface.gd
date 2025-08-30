class_name trinketInterface extends MarginContainer

var id: String 	#Id of the trinket

func _ready() -> void:
	%Preview.visible = false

##Set the trinket label and texture
func setTrinket(trinket: AbstractTrinket) -> void :
	self.id = trinket.id
	%Preview.text = getPreviewText(trinket, Global.trinketsStrings["en"][id]["PREVIEW"])
	%SpriteTrinket.texture = load(trinket.imgPath+"(32x32).png")
	

func getPreviewText(trinket: AbstractTrinket, text: String) -> String :
	var finalText : String = ""
	for t: String in text.split("!"):
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

##When the mouse entered the trinket illustration, we show a preview of effect
func _on_sprite_trinket_mouse_entered() -> void:
	%Preview.visible = true

func _on_sprite_trinket_mouse_exited():
	%Preview.visible = false
