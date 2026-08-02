extends AbstractUnit
class_name AbstractMC

# var form: idk  -> will be used later for upgrades
var livesRemaining: int = 2     # Number of remaining lives (not reset between missions)

## Override death effet for main characters, they return to hand instead of dying if livesRemaining > 0
func onDeath(unit: AbstractUnit = null) -> void:
	for effect: AbstractEffect in effects:
		effect.onDeath(unit)
	for trinket: AbstractTrinket in player.trinkets:
		trinket.onDeath(unit, self)
	
	livesRemaining -= 1
	
	if livesRemaining > 0:
		# MC survives and is returned to the player's hand with all its HP
		hpActual = hpMax
		
		# Create snapshot of the unit with its equipment and modifiers
		var storedData: StoredUnit = StoredUnit.createFromUnit(self)
		
		# Give back to hand
		if player != null:
			player.addUnitCard(storedData)
		
		# Remove self from the field without unequipping or triggering a loss
		removeSelfWithoutUnequip(false)
	else:
		# No more lives: MC is permanently defeated and game is lost
		isDead = true
		removeSelf(true)

## Remove the unit from the field without unequipping it or triggering a loss
func removeSelfWithoutUnequip(checkWin: bool) -> void:
	if player != null:
		player.removeUnit(self)
	if tile != null:
		tile.unitOn = null
	if TurnManager.turn != 0 && checkWin:
		GameManager.checkWin()
	queue_free()

