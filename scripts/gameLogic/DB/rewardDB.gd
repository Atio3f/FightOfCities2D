extends Node


const REWARDS = {
	"reward:unitMonkey" : preload("res://Ressources/rewards/UnitMonkeyReward.gd"),
	"reward:magicalBeast" : preload("res://Ressources/rewards/MagicalBeastReward.gd"),
	"reward:trinketBoss" : preload("res://Ressources/rewards/TrinketBossReward.gd")
}

#A CHANGER faudra que ça soit en fonction de la langue les desc et title, sûrement grâce à la valeur de rewardType
const REWARDS_DICO = {
	"set1:Monkey": {"title": "Monkey", "desc": "A Monkey who tried its best.", "idReward": "set1:Monkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:KnightMonkey": {"title": "Knight Monkey", "desc": "He always help the weakest.", "idReward": "set1:KnightMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:AbominationMonkey": {"title": "Abomination Monkey", "desc": "A failed experiementation. Poor Monkey...", "idReward": "set1:AbominationMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:QueenMonkey": {"title": "Queen Monkey", "desc": "Did you expected to touch a queen?", "idReward": "set1:QueenMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:GodMonkey": {"title": "God Monkey", "desc": "The god of all Monkeys.", "idReward": "set1:GodMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:BlueMushroom": {"title": "Blue Mushroom", "desc": "A very stubborn mushroom.", "idReward": "set1:BlueMushroom", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:TemporalSnail": {"title": "Temporal Snail", "desc": "A Snail who can rewrite reality itself.", "idReward": "set1:TemporalSnail", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:OrbCrate": {"title": "Orb Crate", "desc": "Some orbs on a box.", "idReward": "set1:OrbCrate", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:ArtOfWar": {"title": "Art Of War", "desc": "Learn the tactic's basics.", "idReward": "set1:ArtOfWar", "rewardType": RewardTypes.rewardTypes.TRINKET}
}
