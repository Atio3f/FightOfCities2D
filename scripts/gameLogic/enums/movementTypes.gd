extends Node

enum movementTypes {
	NONE,
	WALK,
	FLYING,
	SWIMMING,
	ATTACK	#For dijsktra calcs
}

# Indicate if an unit is on the ground, in the sky or in water
enum positionCategories {
	GROUNDED, # on the ground
	FLYING, # on the sky
	SWIMMING, # on the water
	UNKNOWN # dead or away
}
