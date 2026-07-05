class_name ItemTargets

# Types de ciblage des items
enum itemTargets {
	UNIT,       # Target units (Avoid having to check all tiles)
	TILE,       # Target tiles (Affect terrain or spawning something on an empty tile)
	BOTH,       # Can target both
	PLAYER,     # Direct use from inventory
	NONE        # Passive items
}
