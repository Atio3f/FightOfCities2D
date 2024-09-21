extends RichTextLabel



#Sert pour les tests internes
#func _ready():
	#position = Vector2(200, 500)
	#placement("+|P|Monkey", 3)

var sourisOnPopUp : bool = true	#La souris est de base pas sur le popUp mais on met true pour éviter des problèmes lors du 1er affichage


func placement(capacite : String, valeurCapa : int) -> void:
	var capaDecom : Array = capacite.split("|", false)
	
	%LabelExplications.position = Vector2(position.x - (size.x/1.9), position.y - 21)
	match(capaDecom[0]):
		"+":
			match(capaDecom[1]):
				
				#Mettre des cas particuliers lorsqu'il y en aura
				#_ = cas par défaut
				_:
					if(capaDecom[2] != "all"):
						%LabelExplications.text = "Donne +%d %s à tous vos %s" % [valeurCapa, capaDecom[1], capaDecom[2]]
					else :
						%LabelExplications.text = "Donne +%d %s à toutes vos unités" % [valeurCapa, capaDecom[1]]
		"-":
			match(capaDecom[1]):
				
				#Mettre des cas particuliers lorsqu'il y en aura
				#_ = cas par défaut
				_:
					if(capaDecom[2] == "allE"):
						%LabelExplications.text = "Retire +%d %s à tous les ennemis" % [valeurCapa, capaDecom[1], capaDecom[2]]
					elif(capaDecom[2].ends_with("E")):
						%LabelExplications.text = "Retire +%d %s à tous les %s ennemis" % [valeurCapa, capaDecom[1], capaDecom[2]]
					elif(capaDecom[2] == "allE"):
						%LabelExplications.text = "Retire +%d %s à tous les %s ennemis" % [valeurCapa, capaDecom[1], capaDecom[2]]
					elif(capaDecom[2] != "all"):
						%LabelExplications.text = "Retire +%d %s à tous vos %s" % [valeurCapa, capaDecom[1], capaDecom[2]]
					else :
						%LabelExplications.text = "Retire +%d %s à toutes vos unités" % [valeurCapa, capaDecom[1]]
					

			
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
