extends AbstractGoal
class_name KillAllGoal

var colorsToKill: Array[TeamsColor.TeamsColor] = []
var killsAtStart: int = 0
var killsRemaining: int = 0

#Called from Campaigns to create new objective
func setupObjective(data: Dictionary) -> void :
	super.setup(data["isPrimary"], data["reward"])
	if data.has("killsAtStart"):
		killsAtStart = data["killsAtStart"]
	else :
		killsAtStart = getRemainingEnemies()
	if data.has("killsRemaining"):
		killsRemaining = data["killsRemaining"]
	else :
		killsRemaining = killsAtStart
	if data.has("colorsToKill") : 
		colorsToKill.assign(data["colorsToKill"].map(func(e): return int(e)))
	
	#checkObjectiveStatus()

func getRemainingEnemies() -> int :
	var count: int = 0
	for color: TeamsColor.TeamsColor in colorsToKill :
		count += GameManager.getPlayer(color).getUnits().size()
	return count

func updateObjective() -> void :
	killsRemaining = getRemainingEnemies()

func getDisplayObjective() -> String :
	return str(killsAtStart - killsRemaining) + "/" + str(killsAtStart)

func checkObjectiveStatus() -> bool :
	isCompleted = killsRemaining == 0 
	return isCompleted


func registerGoal() -> Dictionary :
	return {
		"className": "KillAllGoal",
		"isPrimary": primaryGoal,
		"isCompleted": isCompleted,
		"reward": reward,
		"colorsToKill": colorsToKill,
		"killsAtStart": killsAtStart,
		"killsRemaining": killsRemaining
	}

static func recoverObjective(data: Dictionary) -> AbstractGoal :
	var goal: KillAllGoal = KillAllGoal.new()
	goal.setupObjective(data)
	return goal
