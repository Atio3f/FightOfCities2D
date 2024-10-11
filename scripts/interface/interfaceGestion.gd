extends Control

@onready var labelActionsRest : Label = $FondActionsRestantes/LabelActionsRestantes
@onready var bouttonFinTour : Button = $bouttonFinTour/ButtonFinTour


var sourisOnInterface : bool = false	#Booléan de la présence ou non de la souris sur l'interface
var actionsRest : int = 3	#Temporaire ici faudra la déplacer après dans un endroit global



func setActionsRest(actions : int) -> void:
	labelActionsRest.text = "Actions " + str(actions) + "/3"
	actionsRest = actions



#On crée 2 signaux pour éviter de pouvoir effectuer des actions en ayant le curseur de la souris sur l'interface
func _on_mouse_entered() -> void:
	sourisOnInterface = true


func _on_mouse_exited() -> void:
	sourisOnInterface = false

#Fonction pour réaliser la fin du tour

func _on_button_fin_tour_pressed():
	setActionsRest(3)
	Global.nextTurn()
	#Réalisation d'une boucle pour parcourir toutes les unités sur le terrain et leur permettre de 
	for unit in Global._units :
		Global._units[unit].nextTurn()
