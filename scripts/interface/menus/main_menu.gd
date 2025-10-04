class_name MainMenu extends Control

var campaignBtnScene: PackedScene = preload("res://nodes/menus/campaign_btn.tscn")
var saveBtnScene: PackedScene = preload("res://nodes/menus/save_btn.tscn")
var campaignName: String = ""	#Get the selected campaign
var campaignsAvailable: Array[String] = []	#All campaigns name from the campaignDb
var saves: Array
var save_to_load: Dictionary = {}	#Save which will be loaded

func _ready() -> void:
	%Main.visible = true
	%CampaignSelection.visible = false
	%StartBtn.visible = false
	%CampaignsList.visible = true
	%ContinueMenu.visible = false
	%Settings.visible = false
	#for name in CampaignDb.CAMPAIGNS:
	#	Add a campaign button with the name of the campaign
	#	campaignsAvailable.append(name)
	
	##Get saves and add them to SavesList on Continue Menu
	var savesName : Array[String] = GameManager.getSavesList()
	var saveBtn: SaveBtn
	for save: String in savesName:
		saveBtn = saveBtnScene.instantiate()
		print(save)
		saveBtn.toggleSave(save, self)
		%SavesList.add_child(saveBtn)
		print(saveBtn.visible)

#Show list of campaigns availables
func _on_campaign_selection_btn_pressed():
	%Main.visible = false
	%CampaignSelection.visible = true
	%StartBtn.visible = false
	%CampaignsList.visible = true
	%ContinueMenu.visible = false
	%Settings.visible = false

func _on_start_btn_pressed():
	if campaignName != "":	#Will need to be automatized later when we will have many campaings
		##Create the campaign with the starting config & place it on a new GameManager
		var campaign: AbstractCampaign = load(CampaignDb.CAMPAIGNS[campaignName]).new(campaignName)
		campaign.startCampaign(0)
		Global.change_gameM_instance(campaign)
		Global.gameManager.configPlayer(Global.gameManager.getMainPlayer())	#We want to use it only on load for a new campaign not when we load a save
		print("STARTING CAMPAIGN")
		print(GameManager.campaign.startingAllies)
		GameManager.campaign.startNextMission()
		print("END _on_start_btn_pressed")
		print(MapManager.activeTiles)	#Vide ça a pas dû charger quoi que ce soit
		get_tree().change_scene_to_file("res://scenes/scene_1.tscn")

func _on_monkeys_campaign_btn_pressed():
	%StartBtn.visible = true
	%CampaignsList.visible = false
	campaignName = "set1:MonkeysCampaign"


func _on_settings_btn_pressed():
	%Main.visible = false
	%CampaignSelection.visible = false
	%Settings.visible = true


func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		%Main.visible = true
		%CampaignSelection.visible = false
		%ContinueMenu.visible = false
		%Settings.visible = false
		campaignName = ""


func _on_continue_btn_pressed():
	%Main.visible = false
	%CampaignSelection.visible = false
	%ContinueMenu.visible = true
	%Settings.visible = false
	%LoadSaveBtn.visible = false
	%SavesList.visible = true

func loadSave(save: Dictionary) -> void: 
	save_to_load = save
	%LoadSaveBtn.visible = true
	%SavesList.visible = false

##Load the save and
func _on_load_save_btn_pressed():
	GameManager.loadSave(save_to_load)
	get_tree().change_scene_to_file("res://scenes/scene_1.tscn")
