extends Node

enum DamageTypes {
	PHYSICAL, # DR to reduce amt
	MAGICAL, # MR to reduce amt
	PURE, # Ignore DR and MR
	THORNS, # Damage type of thorns and reflect damage effects
	POISON, # Damage type of poison effect
	FIRE, # Damage type of burn effect and some attacks 
	UNKNOW
}
