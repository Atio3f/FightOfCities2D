class_name EffectDisplay extends MarginContainer


func generate(effect: AbstractEffect) -> void:
	%PreviewEffect.text = effect.getDescription()
	%PreviewEffect.visible = false


func _on_btn_effect_mouse_entered():
	%PreviewEffect.visible = true


func _on_btn_effect_mouse_exited():
	%PreviewEffect.visible = false
