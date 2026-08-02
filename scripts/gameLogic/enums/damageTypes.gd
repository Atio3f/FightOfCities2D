extends Node

enum DamageTypes {
	PHYSICAL, # DR to reduce amt
	MAGICAL, # MR to reduce amt
	PURE, # Ignore DR and MR
	POISON, # Damage type of poison effect
	FIRE, # Damage type of burn effect and some attacks 
	UNKNOW
}
