extends Control
class_name interfaceFinTour

@onready var labelActionsRest : Label = $FondActionsRestantes/LabelActionsRestantes
@onready var bouttonFinTour : Button = $bouttonFinTour/ButtonFinTour


var sourisOnInterface : bool = false	#Booléan de la présence ou non de la souris sur l'interface
var actionsRest : int = 3	#Temporaire ici faudra la déplacer après dans un endroit global
@onready var mainPlayer : AbstractPlayer = $"../.."	#Player associated to the interface

func _ready() -> void :
	updateInterface()

#Update interface on new turn
func updateInterface() -> void:
	#We check if we are during the preparation turn
	if TurnManager.turn == 0 :
		%LabelEndTurn.text = "START BATTLE"
		%LabelCouleurTour.text = "Weight %s/%s" % [mainPlayer.weight, mainPlayer.maxWeight]	#We show the weight remaining of the player during preparation turn
		%ButtonFinTour.disabled = (mainPlayer.getUnits().size() == 0)	#We can't go outside preparation turn without units on board
	else :
		%LabelEndTurn.text = "END OF TURN"
		setActionsRest(3)
		%LabelCouleurTour.text = "Tour %s" % [TurnManager.turn]
		if TurnManager.actualTurn() == mainPlayer.team :
			%LabelActionsRestantes.text = "A vous de jouer"
		else :
			%LabelActionsRestantes.text = "Au tour de "+ str(TurnManager.actualTurn())

func setActionsRest(actions : int) -> void:
	labelActionsRest.text = "Actions " + str(actions) + "/3"
	actionsRest = actions



#On crée 2 signaux pour éviter de pouvoir effectuer des actions en ayant le curseur de la souris sur l'interface
#Me demandait pas pourquoi lorsque la souris rentre dans l'interface on met false et inversement, c'est parce que
# si il détecte un élément de l'interface il va considérer qu'on sort de l'interface, pareil quand on sort de la fenêtre de jeu
func _on_mouse_entered() -> void:
	sourisOnInterface = false
	print("mouseEntered")


func _on_mouse_exited() -> void:
	sourisOnInterface = true
	print("mouseExited")

#Fonction pour réaliser la fin du tour
func _on_button_fin_tour_pressed() -> void:
	setActionsRest(3)
	TurnManager.nextTurn()
	updateInterface()
