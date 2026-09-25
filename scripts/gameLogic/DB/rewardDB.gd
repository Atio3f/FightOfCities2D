extends Node


const REWARDS := {
	## Units reward
	"reward:unitMonkey" : preload("res://Ressources/rewards/UnitMonkeyReward.gd"),
	"reward:magicalBeast" : preload("res://Ressources/rewards/MagicalBeastReward.gd"),
	"reward:unitBull" : preload("res://Ressources/rewards/UnitBullReward.gd"),
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
var REWARDS_DICO := {
	"gold": {"title": "Gold", "desc": "Gain a certain amount of gold",  "rewardType": RewardTypes.rewardTypes.GOLD, "icon_name": "BananaCoin.png"},
	
	## UPGRADES
	"bonus": {"title": "Bonus", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS},
	"UpgradeAgilityEffect": {"title": "Bonus agility", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_COMMON},
	"UpgradePromotionEffect": {"title": "Bonus promotion", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_UNCOMMON},
	"UpgradeScoutEffect": {"title": "Bonus scout", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_COMMON},
	"UpgradeBloodyEffect": {"title": "Bonus bloody", "desc": "Unit have developed an insatiable bloody hunger",  "rewardType": RewardTypes.rewardTypes.BONUS, "icon_name": "BloodyUpgrade.png", "rarity": Rarities.BONUS_COMMON},
	"UpgradeHiddenPotentialEffect": {"title": "Bonus Hidden Potential", "desc": "+1 Potential",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_RARE},
	"UpgradeBloodGiftEffect": {"title": "Bonus Blood Gift", "desc": "+1 Potential, -5 HP, +1 P",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_UNCOMMON},
	"UpgradeTestEffect": {"title": "Bonus test", "desc": "+9 HP",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_COMMON},
	"UpgradeSneakyEffect": {"title": "Bonus sneaky", "desc": "Develop unit capacities",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_UNCOMMON},
	"UpgradeGlassCanonEffect": {"title": "Bonus Glass Canon", "desc": "Less hp for more damage. What a great deal !",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_COMMON},
	"UpgradeMultitaskingEffect": {"title": "Bonus Multitasking", "desc": "Attack one more time each turn",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_UNCOMMON},
	"UpgradeCrossfitDudeEffect": {"title": "Bonus Crossfit training", "desc": "It takes time to develop a hybrid body",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_COMMON},
	"UpgradeCursedEffect": {"title": "Bonus Self Curse", "desc": "Fragilize yourself to curse a random enemy each turn",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_RARE},
	"UpgradeFragileEffect": {"title": "Bonus Fragile", "desc": "+5 P and +1 V, lose 2 DR on each hit taken",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_UNCOMMON},
	"UpgradeStealthilyEffect": {"title": "Bonus Pas de loup", "desc": "+1 P and -4 Aggro",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_COMMON},
	"UpgradeFortuneWheelEffect": {"title": "Bonus Roue de la Fortune", "desc": "Au début de chaque combat, donne +2 DR, +3 P et +2 V à une de vos unités aléatoirement",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_UNCOMMON},
	"UpgradeWasteTreatmentEffect": {"title": "Bonus Retraitement des déchets", "desc": "+1 W. Soin de 6 lorsque vous utilisez un objet",  "rewardType": RewardTypes.rewardTypes.BONUS, "rarity": Rarities.BONUS_COMMON},
	
	## UNITS
	"set1:Monkey": {"title": "Monkey", "desc": "A Monkey who tried its best.", "idReward": "set1:Monkey", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "Monkey_p.png", "rarity": Rarities.UNIT_COMMON},
	"set1:KnightMonkey": {"title": "Knight Monkey", "desc": "He always help the weakest.", "idReward": "set1:KnightMonkey", "rewardType": RewardTypes.rewardTypes.UNIT, "rarity": Rarities.UNIT_COMMON},
	"set1:AbominationMonkey": {"title": "Abomination Monkey", "desc": "A failed experiementation. Poor Monkey...", "idReward": "set1:AbominationMonkey", "rewardType": RewardTypes.rewardTypes.UNIT, "rarity": Rarities.UNIT_UNCOMMON},
	"set1:QueenMonkey": {"title": "Queen Monkey", "desc": "Did you expected to touch a queen?", "idReward": "set1:QueenMonkey", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "QueenMonkey_p.png", "rarity": Rarities.UNIT_RARE},
	"set1:GodMonkey": {"title": "God Monkey", "desc": "The god of all Monkeys.", "idReward": "set1:GodMonkey", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "Monkey_p.png", "rarity": Rarities.UNIT_LEGENDARY},
	"set1:Orangutan": {"title": "Orangutan", "desc": "Il n’est peut être pas très fut fut mais vous pouvez toujours compter sur lui en cas de pépins.", "idReward": "set1:Orangutan", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "Monkey_p.png", "rarity": Rarities.UNIT_COMMON},
	"set1:ArcherMonkey": {"title": "Archer Monkey", "desc": "Efficace contre les unités aériennes.", "idReward": "set1:ArcherMonkey", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "ArcherMonkey_p.png", "rarity": Rarities.UNIT_COMMON},
	"set1:SniperMonkey": {"title": "Sniper Monkey", "desc": "Une portée absurde et un tir précis en font un bon sniper", "idReward": "set1:SniperMonkey", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "SniperMonkey_p.png", "rarity": Rarities.UNIT_RARE},
	"set1:PeasantMonkey": {"title": "Peasant Monkey", "desc": "La vie n'a pas été facile pour ce singe, mais il possède en lui un grand potentiel", "idReward": "set1:PeasantMonkey", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "PeasantMonkey_p.png", "rarity": Rarities.UNIT_UNCOMMON},
	### UNITS MAGICAL BEASTS
	"set1:BlueMushroom": {"title": "Blue Mushroom", "desc": "A very stubborn mushroom.", "idReward": "set1:BlueMushroom", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "BlueMushroom_p.png", "rarity": Rarities.UNIT_COMMON},
	"set1:TemporalSnail": {"title": "Temporal Snail", "desc": "A Snail who can rewrite reality itself.", "idReward": "set1:TemporalSnail", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "Monkey_p.png", "rarity": Rarities.UNIT_LEGENDARY},
	"set1:Banâne": {"title": "Banâne", "desc": "Best friend of Monkeys. Probably smarter than a lot of creatures.", "idReward": "set1:Banâne", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "Monkey_p.png", "rarity": Rarities.UNIT_UNCOMMON},
	"set1:UnyieldingBear": {"title": "Unyielding Bear", "desc": "Les attaques subies le renforcent", "idReward": "set1:UnyieldingBear", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "UnyieldingBear_p.png", "rarity": Rarities.UNIT_COMMON},
	"set1:Fripouille": {"title": "Fripouille", "desc": "Démarre le combat avec des bonus de stat", "idReward": "set1:Fripouille", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "Fripouille_p.png", "rarity": Rarities.UNIT_COMMON},
	"set1:CADO": {"title": "CADO", "desc": "Un chât Adorable Détestant les Oiseaux", "idReward": "set1:CADO", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "CADO_p.png", "rarity": Rarities.UNIT_RARE},
	"set1:StarvingShadow": {"title": "Starving Shadow", "desc": "Perd des PV Max chaque tour. Retourne à 60 PV Max à chaque kill", "idReward": "set1:StarvingShadow", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "StarvingShadow_p.png", "rarity": Rarities.UNIT_LEGENDARY},
	"set1:AtlasLion": {"title": "Atlas Lion", "desc": "Ses dégâts augmentent pour chaque grade de différence avec l'ennemi", "idReward": "set1:AtlasLion", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "AtlasLion_p.png", "rarity": Rarities.UNIT_LEGENDARY},
	### UNITS BULL
	"set1:Bull": {"title": "Bull", "desc": "Un Taureau basique, puissant et colérique", "idReward": "set1:Bull", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "Bull_p.png", "rarity": Rarities.UNIT_COMMON},
	"set1:WingedBull": {"title": "Winged Bull", "desc": "Un Taureau plus sage doté d'ailes pour voler", "idReward": "set1:WingedBull", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "WingedBull_p.png", "rarity": Rarities.UNIT_UNCOMMON},
	"set1:BerserkerBull": {"title": "Berserker Bull", "desc": "Ce barbare se lance tout entier au combat, x2 aux dégâts subis et infligés", "idReward": "set1:BerserkerBull", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "BerserkerBull_p.png", "rarity": Rarities.UNIT_RARE},
	"set1:HornedMonkBull": {"title": "Horned Monk Bull", "desc": "Un Taureau qui a choisi une voie plus noble que ces congénères sanglants. Réduit la puissance des unités qu'il attaque", "idReward": "set1:HornedMonkBull", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "HornedMonkBull_p.png", "rarity": Rarities.UNIT_COMMON},
	"set1:SentinelBull": {"title": "Sentinel Bull", "desc": "Un Taureau en armure armée d'une lance, peu puissant au contact", "idReward": "set1:SentinelBull", "rewardType": RewardTypes.rewardTypes.UNIT, "icon_name": "SentinelBull_p.png", "rarity": Rarities.UNIT_UNCOMMON},
	
	## TRINKETS
	"set1:OrbCrate": {"title": "Orb Crate", "desc": "Some orbs on a box.", "idReward": "set1:OrbCrate", "rewardType": RewardTypes.rewardTypes.TRINKET, "icon_name": "OrbCrate_p.png", "rarity": Rarities.TRINKET_COMMON},
	"set1:FairyBenediction": {"title": "Fairy Benediction", "desc": "Heal 2 random wounded units every turn", "idReward": "set1:FairyBenediction", "rewardType": RewardTypes.rewardTypes.TRINKET, "rarity": Rarities.TRINKET_COMMON},
	"set1:ArtOfWar": {"title": "Art Of War", "desc": "Learn the tactic's basics.", "idReward": "set1:ArtOfWar", "rewardType": RewardTypes.rewardTypes.TRINKET, "icon_name": "ArtOfWar_p.png", "rarity": Rarities.TRINKET_COMMON},
	"set1:GiftedRecruit": {"title": "Gifted Recruit", "desc": "Your next recruit will gain 2 permanent upgrades", "idReward": "set1:GiftedRecruit", "rewardType": RewardTypes.rewardTypes.TRINKET, "icon_name": "WarBanner_p.png", "rarity": Rarities.TRINKET_COMMON},
	"set1:PunchingBallMonkey": {"title": "Punching Ball Monkey", "desc": "Train weakest units", "idReward": "set1:PunchingBallMonkey", "rewardType": RewardTypes.rewardTypes.TRINKET, "icon_name": "PunchingBallMonkey_p.png", "rarity": Rarities.TRINKET_UNCOMMON},
	"set1:MonkeySoap": {"title": "Monkey Soap", "desc": "Clean Monkeys fur to strengthen it", "idReward": "set1:MonkeySoap", "rewardType": RewardTypes.rewardTypes.TRINKET, "icon_name": "MonkeySoap_p.png", "rarity": Rarities.TRINKET_COMMON},
	"set1:BananaRecipes": {"title": "Banana Recipes", "desc": "Give some bananas and increases heal value on bananas", "idReward": "set1:BananaRecipes", "rewardType": RewardTypes.rewardTypes.TRINKET, "icon_name": "BananaRecipes_p.png", "rarity": Rarities.TRINKET_UNCOMMON},
	"set1:HRDiploma": {"title": "HR Diploma", "desc": "New recruits should be better now. Right ?", "idReward": "set1:HRDiploma", "rewardType": RewardTypes.rewardTypes.TRINKET, "icon_name": "BananaRecipes_p.png", "rarity": Rarities.TRINKET_COMMON},
	"set1:WarBanner": {"title": "War Banner", "desc": "Rally your units with this banner. Make them a little bit stronger.", "idReward": "set1:WarBanner", "rewardType": RewardTypes.rewardTypes.TRINKET, "icon_name": "WarBanner_p.png", "rarity": Rarities.TRINKET_COMMON},
	## BOSS TRINKETS
	"set1:LocalHero": {"title": "Local Hero", "desc": "You've proven yourself in these battles", "idReward": "set1:LocalHero", "rewardType": RewardTypes.rewardTypes.TRINKET, "icon_name": "WarBanner_p.png", "rarity": Rarities.TRINKET_SPECIAL},
	
	## ITEMS
	"set1:Banana": {"title": "Banana", "desc": "Good to eat", "idReward": "set1:Banana", "rewardType": RewardTypes.rewardTypes.ITEM, "rarity": Rarities.ITEM_COMMON},
	"set1:BananaPeel": {"title": "Banana Peel", "desc": "Once placed by a wise Monkey, falling is always the end", "idReward": "set1:BananaPeel", "rewardType": RewardTypes.rewardTypes.ITEM, "rarity": Rarities.ITEM_COMMON},
	"set1:VitalLink": {"title": "Vital Link", "desc": "Heal an unit for 10, or more on magical beasts", "idReward": "set1:VitalLink", "rewardType": RewardTypes.rewardTypes.ITEM, "rarity": Rarities.ITEM_COMMON},
	"set1:IcyBreeze": {"title": "Icy Breeze", "desc": "Slow ALL units and randomly freeze", "idReward": "set1:IcyBreeze", "rewardType": RewardTypes.rewardTypes.ITEM, "rarity": Rarities.ITEM_COMMON},
	"set1:TemptationPoison": {"title": "Temptation Poison", "desc": "Poison an unit, more effective on a dumb target", "idReward": "set1:TemptationPoison", "rewardType": RewardTypes.rewardTypes.ITEM, "rarity": Rarities.ITEM_COMMON},
	"set1:AssaultDroneMonkeyDeployment": {"title": "Assault Drone Monkey Deployment", "desc": "Deploy a drone on an empty tile", "idReward": "set1:AssaultDroneMonkeyDeployment", "rewardType": RewardTypes.rewardTypes.ITEM, "rarity": Rarities.ITEM_UNCOMMON},
	"set1:FairyMiracle": {"title": "Fairy Miracle", "desc": "Fully heal an unit", "idReward": "set1:FairyMiracle", "rewardType": RewardTypes.rewardTypes.ITEM, "icon_name": "FairyMiracle.png", "rarity": Rarities.ITEM_RARE},

	## EQUIPMENTS
	"set1:BrambleGauntlet": {"title": "Bramble Gauntlet", "desc": "It spikes on contact !", "idReward": "set1:BrambleGauntlet", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "icon_name": "BrambleGauntlet.png"},
	"set1:LaserBladeMonkey": {"title": "Laser Blade Monkey", "desc": "Blade reserved to Monkeys idk why", "idReward": "set1:LaserBladeMonkey", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "icon_name": "LaserBladeMonkey.png", "rarity": Rarities.EQUIP_COMMON},
	"set1:CoolCapMonkey": {"title": "Cool Cap Monkey", "desc": "Most popular cap for 4 generations", "idReward": "set1:CoolCapMonkey", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "icon_name": "CoolCapMonkey.png", "rarity": Rarities.EQUIP_COMMON},
	"set1:MoonStone": {"title": "Moon Stone", "desc": "A good charm against magical threats", "idReward": "set1:MoonStone", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "rarity": Rarities.EQUIP_COMMON},
	"set1:SwagBananaBag": {"title": "Swag Banana Bag", "desc": "Serve to stock banana", "idReward": "set1:SwagBananaBag", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "rarity": Rarities.EQUIP_UNCOMMON},
	"set1:MudCharm": {"title": "Mud Charm", "desc": "Be nature, heal with time", "idReward": "set1:MudCharm", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "rarity": Rarities.EQUIP_COMMON},
	"set1:WarAxe": {"title": "War Axe", "desc": "Power", "idReward": "set1:WarAxe", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "icon_name": "WarAxe.png", "rarity": Rarities.EQUIP_COMMON},
	"set1:WoodlandDoll": {"title": "Woodland Doll", "desc": "Reflects damage", "idReward": "set1:WoodlandDoll", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "rarity": Rarities.EQUIP_RARE},
	"set1:BouquetOfLies": {"title": "Bouquet of Lies", "desc": "A bouquet of flowers, roses bounce off enemies", "idReward": "set1:BouquetOfLies", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "rarity": Rarities.EQUIP_RARE},
	"set1:ForceMonkeySweater": {"title": "FORCE MONKEY Sweater", "desc": "Boost all Monkeys when equip", "idReward": "set1:ForceMonkeySweater", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "icon_name": "ForceMonkeySweater.png", "rarity": Rarities.EQUIP_RARE},
	"set1:DemonAxe": {"title": "Demon Axe", "desc": "Tradeoff defense for more damage", "idReward": "set1:DemonAxe", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "icon_name": "DemonAxe.png", "rarity": Rarities.EQUIP_UNCOMMON},
	"set1:HarpyBardiche": {"title": "Harpy Bardiche", "desc": "Kill Kill Kill that flying thing", "idReward": "set1:HarpyBardiche", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "icon_name": "HarpyBardiche.png", "rarity": Rarities.EQUIP_COMMON},
	"set1:DreadCloak": {"title": "Dread Cloak", "desc": "Scare ennemies, useful to steal Magical Resistance", "idReward": "set1:DreadCloak", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "rarity": Rarities.EQUIP_UNCOMMON},
	"set1:VampiricFangs": {"title": "Vampiric Fangs", "desc": "Grants LifeSteal", "idReward": "set1:VampiricFangs", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "rarity": Rarities.EQUIP_COMMON},
	"set1:HiddenCrown": {"title": "Hidden Crown", "desc": "Help to control everything without getting targeted", "idReward": "set1:HiddenCrown", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "rarity": Rarities.EQUIP_RARE},
	"set1:ChallengeBoots": {"title": "Challenge Boots", "desc": "These boots cause enemies to focus you", "idReward": "set1:ChallengeBoots", "rewardType": RewardTypes.rewardTypes.EQUIPMENT, "rarity": Rarities.EQUIP_UNCOMMON},
}
