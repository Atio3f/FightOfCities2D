class_name bouttonCapa
extends Button

var capaciteAssociee : Dictionary
var menuCapa : Control
var pointeurJoueur : Node2D		#Indique le joueur qui a actionné la capa de l'unité
#func _ready():
	#placement("+|XP&S|Taureau|EW1", [3, -1, 40, 2])
	#position = Vector2(500, 500)


func placement(interface : Control, capacite : String, valeurCapa : Array) -> void:
	var capaDecom : Array = capacite.split("|", false)
	var descrip : String = ""
	var i : int = 2
	position = Vector2(position.x - (size.x/1.9), position.y - 21)
	
	match(capaDecom[0]):
		_:	#Tous les changements de stats normaux
			var statsChanged : Array = capaDecom[1].split("&", false)
			print(statsChanged)
			
			for stat : String in statsChanged :
				descrip += capaDecom[0] + str(valeurCapa[i]) + stat + " "
				i += 1
			
	match(capaDecom[3]):
		_:	#Cas pour EW
			if (capaDecom[3].begins_with("EW") ):
				if (len(capaDecom[3])>2 ):
					descrip += ": " + (capaDecom[3]).substr(2, capaDecom[3].length() - 2)
				else :
					descrip += ": 1"
	if(capaDecom[2] == "allE"):
		descrip += "Ennemis"
	elif(capaDecom[2].ends_with("E")):
		descrip += capaDecom[2].left(-1) + " ennemis"
	elif(capaDecom[2] != "all"):
		descrip += " Tous"
	else :
		descrip += capaDecom[2]
		
	text = descrip
	capaciteAssociee = {capacite : valeurCapa}
	menuCapa = interface


func _on_mouse_entered() -> void:
	var old_size = size  # Taille actuelle avant redimensionnement
	size = old_size * 1.25
	# Ajustement de la position pour garder le centre
	position -= (size - old_size) / 2


func _on_mouse_exited() -> void:
	var old_size = size  # Taille actuelle avant redimensionnement
	size = old_size * 0.8  
	# Ajustement de la position pour garder le centre
	position -= (size - old_size) / 2

#Permet d'utiliser une capacité
func _on_button_up() -> void:
	print("TEST")
	menuCapa.recuSelectionCapa(capaciteAssociee, pointeurJoueur)
