extends HBoxContainer

func _ready() -> void:
	Global.update_gold.connect(_on_update_gold)
	
	if GameManager.getMainPlayer():
		_on_update_gold(GameManager.getMainPlayer().gold)

func _on_update_gold(gold_amount: int) -> void:
	%GoldLabel.text = str(gold_amount)
