class_name AbstractCampaign extends Node
#Contains all levels from a campaign

var campaignFile: String	#File path of the file with all dialogs & list of units/items available for the campaign, will also contains mainCharacter id
var mainCharacter: String	#Id of the main character
var startingAllies: Array	#Array with all allies id on the starting team 
var startingItems: Array	#Array with all items id on the starting team 
var startingTrinkets: Array	#Array with all trinkets id on the starting team 
var startingOrbs: int #Number of orbs at the start of the campaign
var startingMaxOrbs: int #Max orbs at the start of the campaign

var difficulty: int	#Ascension like system, start at 0 and will go up to 5
var progress: int = 0	#Actual level on the campaign

func setupCampaign(difficulty: int, campaignFile: String) -> void :
	self.difficulty = difficulty
	self.progress = 1
	self.campaignFile = campaignFile
	#Get all informations from the campaign on its file
	var file : FileAccess = FileAccess.open(self.campaignFile, FileAccess.READ)
	if file :
		var content : String = file.get_as_text()
		var data: Dictionary = JSON.parse_string(content)
		mainCharacter = data.get("mainCharacter", "")
		startingAllies = data.get("startingAllies", [])
		startingItems = data.get("startingItems", [])
		startingTrinkets = data.get("startingTrinkets", [])
		startingOrbs = data.get("startingOrbs", 0)
		startingMaxOrbs = data.get("startingMaxOrbs", 0)
	else :
		push_error("FILE FOR CAMPAIGN"+campaignFile+" NOT FOUND")
