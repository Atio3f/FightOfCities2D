extends Button
class_name bouttonCapa


var capaciteAssociee : AbstractCapacity
var menuCapaI : menuCapa
var pointeurJoueurI : pointeurJoueur		#Indique le joueur qui a actionné la capa de l'unité

func placement(interface : Control, pointeurJ : Node2D, capaciteI : AbstractCapacity) -> void:
	var capaNom : String = capaciteI.nameCapacity
	
	if capaciteI.maxUses != -1:
		text = "%s %d/%d" % [capaNom, capaciteI.usesRemaining, capaciteI.maxUses]
	else:
		text = capaNom
		
	if capaciteI.currentCooldown > 0:
		text += " (CD: %d)" % capaciteI.currentCooldown
		disabled = true
	elif capaciteI.usesRemaining == 0:
		disabled = true
	
	capaciteAssociee = capaciteI
	menuCapaI = interface
	pointeurJoueurI = pointeurJ
	


func _on_mouse_entered() -> void:
	var old_size = custom_minimum_size
	if old_size.x < 10:
		old_size = size
	custom_minimum_size = old_size * 1.05


func _on_mouse_exited() -> void:
	var old_size = custom_minimum_size
	if old_size.x < 10:
		old_size = size
	custom_minimum_size = old_size / 1.05

func _ready():
	# On s'assure d'écouter manuellement sur pressed car button_up peut être capricieux si la taille de la box bouge
	if not self.pressed.is_connected(_on_pressed_custom):
		self.pressed.connect(_on_pressed_custom)
	custom_minimum_size = Vector2(250, 40) # Assure une taille physique cliquable

func _on_pressed_custom() -> void:
	print("Bouton capa pressé : " + capaciteAssociee.nameCapacity)
	if menuCapaI and capaciteAssociee:
		menuCapaI.recuSelectionCapa(capaciteAssociee, pointeurJoueurI)

# L'ancienne fonction au cas où le signal serait toujours attaché depuis la scène
func _on_button_up() -> void:
	print("Bouton up triggered")
	_on_pressed_custom()
