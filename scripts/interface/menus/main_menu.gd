class_name MainMenu extends Control

var campaignBtn: PackedScene = preload("res://nodes/menus/campaign_btn.tscn")
var campaignName: String = ""	#Get the selected campaign
var campaignsAvailable: Array[String] = []	#All campaigns name from the campaignDb

func _ready() -> void:
	%Main.visible = true
	%CampaignSelection.visible = false
	%StartBtn.visible = false
	%CampaignsList.visible = true
	%Settings.visible = false
	#for name in CampaignDb.CAMPAIGNS:
	#	Add a campaign button with the name of the campaign
	#	campaignsAvailable.append(name)
#Show list of campaigns availables
func _on_campaign_selection_btn_pressed():
	%Main.visible = false
	%CampaignSelection.visible = true
	%StartBtn.visible = false
	%CampaignsList.visible = true
	%Settings.visible = false

func _on_start_btn_pressed():
	if campaignName != "":	#Will need to be automatized later when we will have many campaings
		GameManager.campaign = load(CampaignDb.CAMPAIGNS[campaignName]).new()
		GameManager.campaign.startCampaign(0)
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
		%Settings.visible = false
		campaignName = ""
