extends Node


const REWARDS = {
	"reward:unitMonkey" : preload("res://Ressources/rewards/UnitMonkeyReward.gd")
}

const REWARDS_DICO = {
	"set1:Monkey": {"title": "Monkey", "desc": "A Monkey who tried its best", "idReward": "set1:Monkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:KnightMonkey": {"title": "Knight Monkey", "desc": "He always help the weakest.", "idReward": "set1:KnightMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:AbominationMonkey": {"title": "Abomination Monkey", "desc": "A failed experiementation. Poor Monkey...", "idReward": "set1:AbominationMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:QueenMonkey": {"title": "Queen Monkey", "desc": "Did you expected to touch a queen?", "idReward": "set1:QueenMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:GodMonkey": {"title": "God Monkey", "desc": "The god of all Monkeys", "idReward": "set1:GodMonkey", "rewardType": RewardTypes.rewardTypes.UNIT}
}
