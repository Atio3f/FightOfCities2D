extends cartePlacableRessource
class_name uniteRessource


#@export var D : int		#Défense permet d'avoir plus de PV a été retiré pour simplifier

@export var S : int		#Sagesse permet d'xp plus vite
@export_range(1, 4) var G : int		#Grade permet de classer les unités, les unités G1 seront présent en 4exemplaires, les G2 en 3exemplaires
@export_enum("Monkey", "Penguin","Chauve-Souris","Humain", "Taureau","Autres") var race : String



@export_range(1, 3) var niveau : int	#Le niveau de l'unité. Les niveaux 2 et 3 donnent chacun 50% de pv bonus ainsi que 1 DR
const paliersNiveaux = [0, 100, 250, 9999]	#L'expérience nécessaire pour monter au niveau 2(100) puis pour monter au niveau 3(250)
@export var XP : float #L'expérience obtenue par l'unité (Le calcul est : dégâts infligés + S lors d'une attaque et pv unité tuée + 2S lors d'un kill
