extends Node
class_name AbstractGoal
## Class used to create new level objectives

signal goal_updated(title: String, status: String, completed: bool) #Signal sent to goal interface to update
signal goal_delete() #Signal sent to goal interface to delete it

var isCompleted: bool = false #Allow us to avoid checking 
var primaryGoal: bool = true #Allow to add secondary goals that could add reward
var reward: String = "None" #Stock reward id, if reward == null there is no reward
## Variables will be created and manage in children classes

func _init():
	pass

# Create the objective and add its infos on player interface
func setup(isPrimary: bool, reward: String) -> void :
	primaryGoal = isPrimary
	self.reward = reward
	GameManager.getMainPlayer().addGoalInterface(self)


func updateObjective() -> void :
	#Send a signal to the interface to send new display objective value
	updateDisplay()

# Return if goal is completed or not
func checkObjectiveStatus() -> bool :
	return isCompleted

## Update goal display on interface with new values
func updateDisplay() -> void :
	# Send signal to interface
	goal_updated.emit(
		getDisplayObjectiveTitle(), 
		getDisplayObjectiveStatus(), 
		isCompleted
	)

## Return string used to display on interface the goal title
func getDisplayObjectiveTitle() -> String :
	return "unknowObjective"

## Return string used to display on interface the goal state 
func getDisplayObjectiveStatus() -> String :
	return "unknowStatus"

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
