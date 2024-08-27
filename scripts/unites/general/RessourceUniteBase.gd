extends Resource

class_name uniteRessource

@export var nom : String	#Le nom de l'unité
@export var pv_max : int	#Equivalent de D + 20 qui servait à calculer les pv des unités avant
@export var pv_actuels : int
var pvTemporaires : int		#PV bonus qui ne peuvent pas être guéris, souvent obtenus depuis des objets et ne sont pas augmentés lorsque l'unité monte de niveau
@export var image : Texture		#Sprite de l'unité
@export var P : int		#Puissance permet de faire plus de dégâts
#@export var D : int		#Défense permet d'avoir plus de PV a été retiré pour simplifier
@export var DR : int #Permet de réduire les dégâts subis(1DR = 1dégâts subi en moins par attaque)
@export var V : int		#Vitesse permet de se déplacer plus loin
@export var S : int		#Sagesse permet d'xp plus vite
@export_range(1, 4) var G : int		#Grade permet de classer les unités, les unités G1 seront présent en 4exemplaires, les G2 en 3exemplaires
@export_enum("Monkey", "Penguin","Chauve-Souris","Humain", "Autres") var race : String
@export_range(1, 20) var range : int	#Distance d'attaque de l'unité
@export var couleurEquipe : String 	#Permet d'indiquer l'équipe de l'unité
@export var attaquesMax : int	#Le nombre d'attaques maximales réalisables par l'unité
@export var attaquesRestantes : int 	#Le nombre d'attaques qu'il reste à l'unité ce tour
@export var vitesseRestante : int	#Le nombre de V qu'il reste à l'unité pour se déplacer
@export_range(1, 3) var niveau : int	#Le niveau de l'unité. Les niveaux 2 et 3 donnent chacun 50% de pv bonus ainsi que 1 DR
const paliersNiveaux = [100, 250]	#L'expérience nécessaire pour monter au niveau 2(100) puis pour monter au niveau 3(250)
@export var experience : float #L'expérience obtenue par l'unité (Le calcul est : dégâts infligés + S lors d'une attaque et pv unité tuée + 2S lors d'un kill


##Capacités est un dictionnaire avec comme clé le moment où la capacité est utilisée et comme valeur une liste de toutes les capacités de l'unité :
	#Précision pour les clés :
	#PlacementBased = tout ce qui s'active lorsque l'unité est placée
	#PermanentBuff = tout les buffs qui durent tant que l'unité est en vie
	#TurnBased = tout ce qui s'active au début où à la fin des tours
	#ItemBased = tout ce qui s'active lorsque l'on utilise un objet sur l'unité
	#MovementBased = tout ce qui s'active lorsque l'unité bouge
	#AttackBased = tout ce qui s'active lorsque l'unité attaquez
	#KillBased = tout ce qui s'active lorsque l'unité tue une autre unité
	#DefenseBased = tout ce qui s'active lorsque l'unité prend des dégâts ou se fait attaquer
	#DeathBased = tout ce qui s'active quand l'unité meurt
@export var capacites : Dictionary = {"PlacementBased" : {},"PermanentBuff" : {}, "TurnBased" : {}, "ItemBased" : {}, "MovementBased" : {}, "AttackBased" : {}, "KillBased" : {},"DefenseBased" : {}, "DeathBased": {}}
