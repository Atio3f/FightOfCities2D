extends Node2D
const paliersTaille : Array = [0, 22, 26, 31, 38, 44, 50]	#Paliers qui permettent d'augmenter la taille de la police
const tailles : Array = [8, 9, 10, 11, 12, 13, 15]

const police5 : Resource = preload("res://assets/interface/unite/polices/Beef'd.ttf")	#Servira si on veut ajuster la police en fonction de la taille


@onready var labelValeur : Label = $ValeurDegats


#Fais apparaître l'indicateur de dégâts sur l'écran pendant quelques secondes en fonction de la valeur entrée
#Fonction appellé dans subirDegats
func newPopUp(valeur : int) -> void:
	var taille : int = 0
	while(taille<len(paliersTaille)-1 and (valeur >= paliersTaille[taille])):
		taille += 1
	labelValeur.text = str(valeur)
	labelValeur.label_settings.font_size = tailles[taille]
	var tween = create_tween()
	
	tween.tween_property(self, "position", Vector2(position.x + 0,  position.y - 38), 1.2)
	tween.parallel().tween_property(self, "scale", Vector2(1.1, 1.1), 1.1)		#parallel permet de faire cette animation en même temps que la précédente
	
	tween.tween_callback(self.queue_free)
	 
	#queue_free()
