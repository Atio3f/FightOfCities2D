extends Node
class_name AbstractGoal
## Class used to create new level objectives

var isCompleted: bool = false #Allow us to avoid checking 
var primaryGoal: bool = true #Allow to add secondary goals that could add reward
var reward: String = "None" #Stock reward id, if reward == null there is no reward
## Variables will be created and manage in children classes

func _init():
	pass

# Create the objective
func setup(isPrimary: bool, reward: String) -> void :
	primaryGoal = isPrimary
	self.reward = reward


func updateObjective() -> void :
	pass
	#TODO ? Send a signal to the interface to send new display objective value

# Return if goal is completed or not
func checkObjectiveStatus() -> bool :
	return isCompleted

## Return string used to display on interface the goal state 
func getDisplayObjective() -> String :
	return "unknowObjective"


func getReward() -> String :
	#Case of reward == "None" will be treated on an other function
	if (isCompleted) : 
		return reward
	else :
		return "None"



func registerGoal() -> Dictionary :
	return {
		
	}

static func recoverObjective(data: Dictionary) -> AbstractGoal :
	if !GoalsDb.GOALS.has(data.className) :
		push_error("Goal class not found on recover objective (%s)" % data.className)
		return null
	#Load resource
	var goalResource: Resource = load(GoalsDb.GOALS[data.className])
	if not goalResource :
		push_error("No goal class found from this path (%s)" % GoalsDb.GOALS[data.className])
		return null
	var goal: AbstractGoal = goalResource.recoverObjective(data) #Goal will recover its own attributes with that
	return goal
