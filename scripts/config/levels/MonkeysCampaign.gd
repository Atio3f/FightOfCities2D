class_name MonkeysCampaign extends AbstractCampaign


const fileName: String = "res://Ressources/campaigns/MonkeysCampaign.json"

func startCampaign(difficulty: int) -> void:
	super.setupCampaign(difficulty, fileName)
