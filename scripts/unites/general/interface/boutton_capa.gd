extends Button
class_name bouttonCapa


var capaciteAssociee : activeCapacite
var menuCapaI : menuCapa
var pointeurJoueurI : pointeurJoueur		#Indique le joueur qui a actionné la capa de l'unité
#func _ready():
	#placement("+|XP&S|Taureau|EW1", [3, -1, 40, 2])
	#position = Vector2(500, 500)


func placement(interface : Control, pointeurJ : Node2D, capaciteI : capacite) -> void:
	var capaNom : String = capaciteI.nom
	
	
	#position = Vector2(position.x - (size.x/1.9), position.y - 21)
	#
	#match(capaDecom[0]):
		#_:	#Tous les changements de stats normaux
			#var statsChanged : Array = capaDecom[1].split("&", false)
			#print(statsChanged)
			#
			#for stat : String in statsChanged :
				#descrip += capaDecom[0] + str(valeurCapa[i]) + stat + " "
				#i += 1
			#
	#match(capaDecom[3]):
		#_:	#Cas pour EW
			#if (capaDecom[3].begins_with("EW") ):
				#if (len(capaDecom[3])>2 ):
					#descrip += ": " + (capaDecom[3]).substr(2, capaDecom[3].length() - 2)
				#else :
					#descrip += ": 1"
	#if(capaDecom[2] == "allE"):
		#descrip += "Ennemis"
	#elif(capaDecom[2].ends_with("E")):
		#descrip += capaDecom[2].left(-1) + " ennemis"
	#elif(capaDecom[2] != "all"):
		#descrip += " Tous"
	#else :
		#descrip += capaDecom[2]
		#
	text = "%s %d/%d" % [capaciteI.nom, capaciteI.nombreUtilisationsRestantes, capaciteI.nombreUtilisationsMax ]
	capaciteAssociee = capaciteI
	menuCapaI = interface
	pointeurJoueurI = pointeurJ
	


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
	menuCapaI.recuSelectionCapa(capaciteAssociee, pointeurJoueurI)
