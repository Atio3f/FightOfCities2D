extends Node
class_name TurnManager
#Manage all end of turn actions and to decide which team have to play

static var turn : int = 0 #Actual turn number, 0 is the preparation turn
static var teams : Array[TeamsColor.TeamsColor] = []	#we stock all the color teams

static func addTeam(teamColor: TeamsColor.TeamsColor) -> void:
	teams.append(teamColor)

#param teams contains all TeamsColor from players
static func createTeams(teamsColor: Dictionary) -> void :
	for team: TeamsColor.TeamsColor in teamsColor:
		teams.append(team)

## Manage all events when a new turn occured, is missing the ennemies movement
static func nextTurn() -> void:
	if not GameManager.isGameActive:
		return
	var endingTeam := actualTurn()
	if turn != 0:
		for unit : AbstractUnit in GameManager.getAllUnits() :
			unit.onEndOfTurn(turn, endingTeam)
		for trinket: AbstractTrinket in GameManager.getMainPlayer().trinkets :
			trinket.onEndOfTurn(turn, endingTeam)

	turn += 1
	var currentTurnColor := actualTurn()
	#Appel de toutes les unités pour appliquer les effets en envoyant le tour actuel et le tour à venir
	for unit : AbstractUnit in GameManager.getAllUnits() :
		unit.onStartOfTurn(turn, currentTurnColor)
	#Iterate through trinket to proc their effect
	for trinket: AbstractTrinket in GameManager.getMainPlayer().trinkets :
		trinket.onStartOfTurn(turn, currentTurnColor)
		
	# Start enemy logic (utility AI) if actual player is an enemy
	var active_player = GameManager.getPlayer(currentTurnColor)
	if active_player != null and not active_player.isGamePlayer:
		var currentRound = turn / max(1, teams.size())
		GameManager.checkDelayedUnits(currentRound)
		
		var ai = active_player.get_node_or_null("AIController")
		if ai != null:
			ai.start_turn()
	# Clear placement tiles on first turn
	if turn == 1 :
		GameManager.getMainPlayer().playerPointer.clear_placeable_cells()
	else :
		if !GameManager.currentGoals.is_empty() : GameManager.checkWin()	#Check if someone won at the start of each turn, but only if there is still some objectives (avoid double check that cause crash or bad result)
	#Animation du bouton et actualisation de l'interface
	# Reactivate end turn button on player turn
	var mainPlayer = GameManager.getMainPlayer()
	if mainPlayer and mainPlayer.has_node("Actions"):
		mainPlayer.get_node("Actions").combatUI.updateInterface()

## Return the actual color of team this turn
## 0 is the preparation turn
static func actualTurn() -> TeamsColor.TeamsColor :
	if teams.size() == 0 : return TeamsColor.TeamsColor.EMPTY
	if turn == 0 : return TeamsColor.TeamsColor.EMPTY
	return teams[(turn - 1) % teams.size()]

## Reset the TurnManager at the end of each map
static func reset() -> void :
	turn = 0
	teams.clear()
	##Replace players team which remained
	for player: AbstractPlayer in GameManager.getPlayers() :
		if !player :
			GameManager.getPlayers().erase(player)
			continue
		teams.append(player.team)
		if player.isGamePlayer : player.addWeight(0)	#Update interface

static func registerTurnM() -> Dictionary:
	var turnData := {
		"turn": turn,
		"teams": teams
	}
	return turnData

static func recoverTurnManager(data: Dictionary) -> void :
	turn = data.turn
	teams.append_array(data.teams)
