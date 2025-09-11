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

##Manage all events when a new turn occured, is missing the ennemies movement
static func nextTurn() -> void:
	var nextTurn := teams[(turn+1) % teams.size()]
	turn += 1
	#Appel de toutes les unités pour appliquer les effets en envoyant le tour actuel et le tour à venir
	for unit : AbstractUnit in GameManager.getAllUnits() :
		unit.onStartOfTurn(turn, nextTurn)
	#Iterate through trinket to proc their effect
	for trinket: AbstractTrinket in GameManager.getMainPlayer().trinkets :
		trinket.onStartOfTurn(turn, nextTurn)
	#Clear placement tiles on first turn
	if turn == 1 :
		GameManager.getMainPlayer().playerPointer.clear_placeable_cells()
	#Animation du bouton et actualisation de l'interface

#Return the actual color of team this turn
static func actualTurn() -> TeamsColor.TeamsColor :
	if teams.size() == 0 : return TeamsColor.TeamsColor.EMPTY
	return teams[turn % teams.size()]

static func registerTurnM() -> Dictionary:
	var turnData := {
		"turn": turn,
		"teams": teams
	}
	return turnData

static func recoverTurnManager(data: Dictionary) -> void :
	turn = data.turn
	teams.append_array(data.teams)
