extends Control
class_name CombatUI

@onready var labelActionsRest : Label = $FondActionsRestantes/LabelActionsRestantes
@onready var bouttonFinTour : EndTurnButton = $bouttonFinTour
var goalDisplayScene: PackedScene = null
var dialogDisplayScene: PackedScene = null

const WARNING_POPUP_SCENE = preload("res://nodes/interface/StartBattleWarningPopup.tscn")
var warning_popup_instance: StartBattleWarningPopup = null

var sourisOnInterface : bool = false	#Booléan de la présence ou non de la souris sur l'interface
var actionsRest : int = 3	#Temporaire ici faudra la déplacer après dans un endroit global
@onready var mainPlayer : AbstractPlayer = $"../../.."	#Player associated to the interface

var dialogsList: Array[DialogInterface] = []
var indexNextDialog: int = 0

var can_pass_turn: bool = true

func _ready() -> void :
	updateInterface()

#Update interface on new turn
func updateInterface() -> void:
	#We check if we are during the preparation turn
	if TurnManager.turn == 0 :
		%LabelCouleurTour.text = tr("UI_LABEL_TEAM_WEIGHT") % [mainPlayer.weight, mainPlayer.maxWeight]	#We show the weight remaining of the player during preparation turn
		bouttonFinTour.setup_mode(true, mainPlayer.getUnits().is_empty())
		%MaxUnitLabel.visible = true
		%MaxUnitLabel.text = tr("UI_LABEL_TEAM_NBR") % [mainPlayer.units.size(), mainPlayer.maxUnits]
	else :
		%MaxUnitLabel.visible = false
		%LabelCouleurTour.text = tr("UI_LABEL_TURN_NUMBER") % [TurnManager.turn / TurnManager.teams.size() + 1]
		if TurnManager.actualTurn() == mainPlayer.team :
			%LabelActionsRestantes.text = tr("UI_LABEL_REMAINING_ACTIONS")
			bouttonFinTour.setup_mode(false, false)
		else :
			%LabelActionsRestantes.text = tr("UI_LABEL_WHICH_PLAYER_TURN") % [str(TurnManager.actualTurn())]
			bouttonFinTour.setup_mode(false, true)

## Add goal on interface
func addGoalInterface(goal: AbstractGoal) -> void :
	if goalDisplayScene == null :
		goalDisplayScene = load("res://nodes/joueur/interface/goal_display.tscn")
	var goalDisplayNode: GoalDisplay = goalDisplayScene.instantiate()
	goalDisplayNode.setGoal(goal)
	%GoalsPanel.add_child(goalDisplayNode)

func setDialogs(dialogs: Array[DialogInterface]) -> void :
	for dialogNode: DialogDisplay in %DialogsList.get_children() :
		dialogNode.queue_free()
	dialogsList = dialogs
	addDialogInterface(dialogsList[0])
	indexNextDialog = 1
	visibilityDialogs(true)


func addDialogInterface(dialog: DialogInterface) -> void :
	if dialogDisplayScene == null :
		dialogDisplayScene = load("res://nodes/joueur/interface/dialog_display.tscn")
	var dialogDisplayNode: DialogDisplay = dialogDisplayScene.instantiate()
	dialogDisplayNode.setDialog(dialog)
	%DialogsList.add_child(dialogDisplayNode)

func visibilityDialogs(visibility: bool) -> void :
	%DialogsContainer.visible = visibility

func _input(event):
	if %DialogsContainer.visible :
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if indexNextDialog >= dialogsList.size() :
					#Remove dialogs part
					visibilityDialogs(false)
				else:
					# show next dialog
					addDialogInterface(dialogsList[indexNextDialog]) 
					indexNextDialog += 1
					get_viewport().set_input_as_handled()


#On crée 2 signaux pour éviter de pouvoir effectuer des actions en ayant le curseur de la souris sur l'interface
#Me demandait pas pourquoi lorsque la souris rentre dans l'interface on met false et inversement, c'est parce que
# si il détecte un élément de l'interface il va considérer qu'on sort de l'interface, pareil quand on sort de la fenêtre de jeu
func _on_mouse_entered() -> void:
	sourisOnInterface = false
	print("mouseEntered")


func _on_mouse_exited() -> void:
	sourisOnInterface = true
	print("mouseExited")

# Fonction pour réaliser la fin du tour
func try_pass_turn() -> void:
	if not can_pass_turn:
		return

	# Pendant le tour 0, il faut au moins 1 unité posée pour activer le bouton
	if TurnManager.turn == 0:
		if mainPlayer.getUnits().is_empty():
			return

		# Check des oublis du joueur pour afficher ou non le popup de validation
		var warnings := StartBattleWarningPopup.get_warnings(mainPlayer)
		if warnings.size() > 0:
			_show_battle_warning_popup(warnings)
			return
	else:
		# En combat, seul le joueur dont c'est le tour peut passer
		if TurnManager.actualTurn() != mainPlayer.team:
			return

	_execute_pass_turn()

## Popup to warn player about forgetfulness before starting the battle
func _show_battle_warning_popup(warnings: Array[String]) -> void:
	if warning_popup_instance == null:
		warning_popup_instance = WARNING_POPUP_SCENE.instantiate()
		add_child(warning_popup_instance)
		warning_popup_instance.confirmed.connect(_execute_pass_turn)
	warning_popup_instance.display_warnings(warnings)

func _execute_pass_turn() -> void:
	can_pass_turn = false
	bouttonFinTour.set_btn_disabled(true)

	TurnManager.nextTurn()
	updateInterface()

	if mainPlayer.playerPointer and mainPlayer.playerPointer.Selection:
		mainPlayer.playerPointer._deselect_active_unit()
	if mainPlayer.playerPointer:
		mainPlayer.playerPointer._clear_active_unit()

	# Avoid double turn pass
	await get_tree().create_timer(0.4).timeout
	can_pass_turn = true
	if is_instance_valid(self):
		updateInterface()

func _on_button_fin_tour_pressed() -> void:
	try_pass_turn()

func _on_help_button_pressed() -> void:
	var help_menu = $HelpMenu
	if help_menu:
		help_menu.visible = not help_menu.visible
