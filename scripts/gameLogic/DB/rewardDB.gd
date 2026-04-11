extends Node


const REWARDS := {
	"reward:unitMonkey" : preload("res://Ressources/rewards/UnitMonkeyReward.gd"),
	"reward:magicalBeast" : preload("res://Ressources/rewards/MagicalBeastReward.gd"),
	"reward:trinketBoss" : preload("res://Ressources/rewards/TrinketBossReward.gd"),
	"reward:classicBanana": preload("res://Ressources/rewards/ClassicBananaReward.gd"),
	"reward:gold" : preload("res://Ressources/rewards/GoldReward.gd"),
	"reward:bonus" : preload("res://Ressources/rewards/UpgradeReward.gd"),
}

#A CHANGER faudra que ça soit en fonction de la langue les desc et title, sûrement grâce à la valeur de rewardType
const REWARDS_DICO := {
	"gold": {"title": "Gold", "desc": "Gain a certain amount of gold",  "rewardType": RewardTypes.rewardTypes.GOLD},
	
	## UPGRADES
	"bonus": {"title": "Bonus", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeAgilityEffect": {"title": "Bonus agility", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradePromotionEffect": {"title": "Bonus promotion", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeScoutEffect": {"title": "Bonus scout", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeHiddenPotentialEffect": {"title": "Bonus hidden potential", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeTestEffect": {"title": "Bonus test", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS},
	
	## UNITS
	"set1:Monkey": {"title": "Monkey", "desc": "A Monkey who tried its best.", "idReward": "set1:Monkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:KnightMonkey": {"title": "Knight Monkey", "desc": "He always help the weakest.", "idReward": "set1:KnightMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:AbominationMonkey": {"title": "Abomination Monkey", "desc": "A failed experiementation. Poor Monkey...", "idReward": "set1:AbominationMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:QueenMonkey": {"title": "Queen Monkey", "desc": "Did you expected to touch a queen?", "idReward": "set1:QueenMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:GodMonkey": {"title": "God Monkey", "desc": "The god of all Monkeys.", "idReward": "set1:GodMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:BlueMushroom": {"title": "Blue Mushroom", "desc": "A very stubborn mushroom.", "idReward": "set1:BlueMushroom", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:TemporalSnail": {"title": "Temporal Snail", "desc": "A Snail who can rewrite reality itself.", "idReward": "set1:TemporalSnail", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:Banâne": {"title": "Banâne", "desc": "Best friend of Monkeys. Probably smarter than a lot of creatures.", "idReward": "set1:Banâne", "rewardType": RewardTypes.rewardTypes.UNIT},
	
	## TRINKETS
	"set1:OrbCrate": {"title": "Orb Crate", "desc": "Some orbs on a box.", "idReward": "set1:OrbCrate", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:ArtOfWar": {"title": "Art Of War", "desc": "Learn the tactic's basics.", "idReward": "set1:ArtOfWar", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:PunchingBallMonkey": {"title": "Punching Ball Monkey", "desc": "TODO", "idReward": "set1:PunchingBallMonkey", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:MonkeySoap": {"title": "Monkey Soap", "desc": "TODO", "idReward": "set1:MonkeySoap", "rewardType": RewardTypes.rewardTypes.TRINKET},
	
	## ITEMS
	"set1:Banana": {"title": "Banana", "desc": "TODO", "idReward": "set1:Banana", "rewardType": RewardTypes.rewardTypes.ITEM},
	"set1:BananaPeel": {"title": "Banana Peel", "desc": "TODO", "idReward": "set1:BananaPeel", "rewardType": RewardTypes.rewardTypes.ITEM},
}
