extends AbstractGoal
class_name SurviveTurnsGoal

var turnsToSurvive: int = 0
var turnsSurvived: int = 0

#Called from Campaigns to create new objective
func setupObjective(data: Dictionary) -> void :
	if data.has("turnsToSurvive"):
		turnsToSurvive = data["turnsToSurvive"]
	super.setup(data["isPrimary"], data["reward"]) # Setup in last to give interface real values at start

func updateObjective() -> void :
	var teamsCount = max(1, TurnManager.teams.size())
	turnsSurvived = TurnManager.turn / teamsCount
	super.updateObjective()

func getDisplayObjectiveTitle() -> String :
	return tr("GOAL_TITLE_SURVIVE_TURNS")

func getDisplayObjectiveStatus() -> String :
	return tr("GOAL_DISPLAY_SURVIVE_TURNS") % [str(turnsToSurvive - turnsSurvived)]

func checkObjectiveStatus() -> bool :
	# The goal fails if all player units die
	if GameManager.getMainPlayer() and GameManager.getMainPlayer().getUnits().size() == 0:
		isCompleted = false
		return false
		
	isCompleted = turnsSurvived >= turnsToSurvive
	return isCompleted


func registerGoal() -> Dictionary :
	return {
		"className": "SurviveTurnsGoal",
		"isPrimary": primaryGoal,
		"isCompleted": isCompleted,
		"reward": reward,
		"turnsToSurvive": turnsToSurvive,
		"turnsSurvived": turnsSurvived
	}

static func recoverObjective(data: Dictionary) -> AbstractGoal :
	var goal: SurviveTurnsGoal = SurviveTurnsGoal.new()
	goal.setupObjective(data)
	if data.has("turnsSurvived"):
		goal.turnsSurvived = data["turnsSurvived"]
	goal.isCompleted = data.get("isCompleted", false)
	return goal
