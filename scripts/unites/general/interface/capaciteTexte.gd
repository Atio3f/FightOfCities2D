extends RichTextLabel
class_name capaciteTexte


#Sert pour les tests internes
#func _ready():
	#position = Vector2(200, 500)
	#placement("+|P|Monkey", 3)

var sourisOnPopUp : bool = true	#La souris est de base pas sur le popUp mais on met true pour éviter des problèmes lors du 1er affichage


func placement(capaciteI : capacite) -> void:
	
	text = capaciteI.nom
	%LabelExplications.text = capaciteI.descriptionCapa
	%LabelExplications.position = Vector2(position.x - (size.x/1.9), position.y - 21)



func _on_mouse_entered() -> void:
	%LayerExplicationsCapa.offset = Vector2(0, -110)
	%LabelExplications.position = Vector2(position.x - (size.x/1.9), position.y )
	%LayerExplicationsCapa.visible = true


func _on_mouse_exited() -> void:
	
	%LayerExplicationsCapa.visible = false
	print("YES")
	#sourisOnPopUp = true	#Sert à éviter des problèmes lorsque l'on retourne sur le texte



	
	
	


	


func _on_label_explications_mouse_entered() -> void:
	sourisOnPopUp = true
	print("??")

func _on_label_explications_mouse_exited() -> void:
	sourisOnPopUp = false
