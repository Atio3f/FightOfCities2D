extends PanelContainer
class_name GoalDisplay

## Set base goal infos & signal to update it later
func setGoal(goal: AbstractGoal) -> void :
	# Connect update signal
	if not goal.goal_updated.is_connected(updateGoal):
		goal.goal_updated.connect(updateGoal)
	# Connect delete signal
	if not goal.goal_delete.is_connected(deleteGoal):
		goal.goal_delete.connect(deleteGoal)
	goal.updateDisplay() #Update display on set

## Update goal display on interface
# isFailed has no utility yet bc we don't have a way to block objective completion but we should be able to even 
func updateGoal(goalTitle: String, goalStatus: String, isFailed: bool) -> void: 
	%GoalTitle.text = goalTitle
	%GoalProgress.text = goalStatus

## Remove this interface when the goal is removed
func deleteGoal() -> void :
	queue_free()
