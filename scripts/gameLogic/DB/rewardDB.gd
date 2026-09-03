extends Node


const REWARDS := {
	## Units reward
	"reward:unitMonkey" : preload("res://Ressources/rewards/UnitMonkeyReward.gd"),
	"reward:magicalBeast" : preload("res://Ressources/rewards/MagicalBeastReward.gd"),
	## Trinkets reward
	"reward:trinketBoss" : preload("res://Ressources/rewards/TrinketBossReward.gd"),
	"reward:localHero" : preload("res://Ressources/rewards/LocalHeroReward.gd"),
	## Items rewards
	"reward:basicItems": preload("res://Ressources/rewards/BasicItemsReward.gd"),
	"reward:classicBanana": preload("res://Ressources/rewards/ClassicBananaReward.gd"),
	## Equipments rewards
	"reward:basicEquipments": preload("res://Ressources/rewards/BasicEquipmentsReward.gd"),
	## Other rewards
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
	"UpgradeBloodyEffect": {"title": "Bonus bloody", "desc": "Unit have developed an insatiable bloody hunger",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeHiddenPotentialEffect": {"title": "Bonus hidden potential", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeBloodGiftEffect": {"title": "Bonus potential in exchange of life", "desc": "+1 Potential, -5 HP, +1 P",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeTestEffect": {"title": "Bonus test", "desc": "+9 HP",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeSneakyEffect": {"title": "Bonus sneaky", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeGlassCanonEffect": {"title": "Bonus Glass Canon", "desc": "Less hp for more damage. What a great deal !",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeMultitaskingEffect": {"title": "Bonus Multitasking", "desc": "Attack one more time each turn",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeCrossfitDudeEffect": {"title": "Bonus Crossfit training", "desc": "Takes time to develop a hybrid body",  "rewardType": RewardTypes.rewardTypes.BONUS},
	
	## UNITS
	"set1:Monkey": {"title": "Monkey", "desc": "A Monkey who tried its best.", "idReward": "set1:Monkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:KnightMonkey": {"title": "Knight Monkey", "desc": "He always help the weakest.", "idReward": "set1:KnightMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:AbominationMonkey": {"title": "Abomination Monkey", "desc": "A failed experiementation. Poor Monkey...", "idReward": "set1:AbominationMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:QueenMonkey": {"title": "Queen Monkey", "desc": "Did you expected to touch a queen?", "idReward": "set1:QueenMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:GodMonkey": {"title": "God Monkey", "desc": "The god of all Monkeys.", "idReward": "set1:GodMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:BlueMushroom": {"title": "Blue Mushroom", "desc": "A very stubborn mushroom.", "idReward": "set1:BlueMushroom", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:TemporalSnail": {"title": "Temporal Snail", "desc": "A Snail who can rewrite reality itself.", "idReward": "set1:TemporalSnail", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:Banâne": {"title": "Banâne", "desc": "Best friend of Monkeys. Probably smarter than a lot of creatures.", "idReward": "set1:Banâne", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:Orangutan": {"title": "Orangutan", "desc": "Il n’est peut être pas très fut fut mais vous pouvez toujours compter sur lui en cas de pépins.", "idReward": "set1:Orangutan", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:ArcherMonkey": {"title": "Archer Monkey", "desc": "Efficace contre les unités aériennes.", "idReward": "set1:ArcherMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:SniperMonkey": {"title": "Sniper Monkey", "desc": "Une portée absurde et un tir précis en font un bon sniper", "idReward": "set1:SniperMonkey", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:UnyieldingBear": {"title": "Unyielding Bear", "desc": "Les attaques subies le renforcent", "idReward": "set1:UnyieldingBear", "rewardType": RewardTypes.rewardTypes.UNIT},
	"set1:Fripouille": {"title": "Fripouille", "desc": "Démarre le combat avec des bonus de stat", "idReward": "set1:Fripouille", "rewardType": RewardTypes.rewardTypes.UNIT},
	
	## TRINKETS
	"set1:OrbCrate": {"title": "Orb Crate", "desc": "Some orbs on a box.", "idReward": "set1:OrbCrate", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:FairyBenediction": {"title": "Fairy Benediction", "desc": "Heal 2 random wounded units every turn", "idReward": "set1:FairyBenediction", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:ArtOfWar": {"title": "Art Of War", "desc": "Learn the tactic's basics.", "idReward": "set1:ArtOfWar", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:PunchingBallMonkey": {"title": "Punching Ball Monkey", "desc": "Train weakest units", "idReward": "set1:PunchingBallMonkey", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:MonkeySoap": {"title": "Monkey Soap", "desc": "Clean Monkeys fur to strengthen it", "idReward": "set1:MonkeySoap", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:BananaRecipes": {"title": "Banana Recipes", "desc": "Give some bananas and increases heal value on bananas", "idReward": "set1:BananaRecipes", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:HRDiploma": {"title": "HR Diploma", "desc": "New recruits should be better now. Right ?", "idReward": "set1:HRDiploma", "rewardType": RewardTypes.rewardTypes.TRINKET},
	"set1:WarBanner": {"title": "War Banner", "desc": "Rally your units with this banner. Make them a little bit stronger.", "idReward": "set1:WarBanner", "rewardType": RewardTypes.rewardTypes.TRINKET},
	## BOSS TRINKETS
	"set1:LocalHero": {"title": "Local Hero", "desc": "You've proven yourself in these battles", "idReward": "set1:LocalHero", "rewardType": RewardTypes.rewardTypes.TRINKET},
	
	## ITEMS
	"set1:Banana": {"title": "Banana", "desc": "Good to eat", "idReward": "set1:Banana", "rewardType": RewardTypes.rewardTypes.ITEM},
	"set1:BananaPeel": {"title": "Banana Peel", "desc": "Once placed by a wise Monkey, falling is always the end", "idReward": "set1:BananaPeel", "rewardType": RewardTypes.rewardTypes.ITEM},
	"set1:IcyBreeze": {"title": "Icy Breeze", "desc": "Slow ALL units and randomly freeze", "idReward": "set1:IcyBreeze", "rewardType": RewardTypes.rewardTypes.ITEM},
	"set1:TemptationPoison": {"title": "Temptation Poison", "desc": "Poison an unit, more effective on a dumb target", "idReward": "set1:TemptationPoison", "rewardType": RewardTypes.rewardTypes.ITEM},

	## EQUIPMENTS
	"set1:BrambleGauntlet": {"title": "Bramble Gauntlet", "desc": "It spikes on contact !", "idReward": "set1:BrambleGauntlet", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:LaserBladeMonkey": {"title": "Laser Blade Monkey", "desc": "Blade reserved to Monkeys idk why", "idReward": "set1:LaserBladeMonkey", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:CoolCapMonkey": {"title": "Cool Cap Monkey", "desc": "Most popular cap for 4 generations", "idReward": "set1:CoolCapMonkey", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:MoonStone": {"title": "Moon Stone", "desc": "A good charm against magical threats", "idReward": "set1:MoonStone", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:SwagBananaBag": {"title": "Swag Banana Bag", "desc": "Serve to stock banana", "idReward": "set1:SwagBananaBag", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:MudCharm": {"title": "Mud Charm", "desc": "Be nature, heal with time", "idReward": "set1:MudCharm", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:WarAxe": {"title": "War Axe", "desc": "Power", "idReward": "set1:WarAxe", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:WoodlandDoll": {"title": "Woodland Doll", "desc": "Reflects damage", "idReward": "set1:WoodlandDoll", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:BouquetOfLies": {"title": "Bouquet of Lies", "desc": "A bouquet of flowers, roses bounce off enemies", "idReward": "set1:BouquetOfLies", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:ForceMonkeySweater": {"title": "FORCE MONKEY Sweater", "desc": "Boost all Monkeys when equip", "idReward": "set1:ForceMonkeySweater", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:DemonAxe": {"title": "Demon Axe", "desc": "Tradeoff defense for more damage", "idReward": "set1:DemonAxe", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
	"set1:HarpyBardiche": {"title": "Harpy Bardiche", "desc": "Kill Kill Kill that flying thing", "idReward": "set1:HarpyBardiche", "rewardType": RewardTypes.rewardTypes.EQUIPMENT},
}
