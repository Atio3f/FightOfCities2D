extends capacite
class_name activeCapacite


#Composition d'une capacité active : clé =  "Operateur|StatsChangees|TypeCiblesOuSelf|LocalisationCibles(Around-1 = self, Around-n = autour à n cases, L-n = ligne de n cases, EW-1 = partout, EW-n = partout pour un nombre de cibles défini)|formeCiblage(une case C-1, carré de taille n C-n, une ligne de n largeur et m longuer l-n-m etc.. + possibilité de faire des &)" -> valeur = [nombreUtilisationsRestantes,durée(-1= infini), DescriptionCapa->s'ajoute à la liste de descript des capacités, valeurs pour chaque stat ] 

var typeZone : String	#Exemple : Around , EW, L
var zoneEffet : int	#Exemple : 3 avec typeZone = Around signifie les cases à 3cases autour de l'unité

var nombreUtilisationsMax : int
var nombreUtilisationsRestantes : int

func _init(newNom : String, newDescription : String, newOperateur : String, newStatsAffectees : Dictionary, newTypeCible : Array, newTypeZone : String, newZoneEffet : int):
	typeZone = newTypeZone
	zoneEffet = newZoneEffet
	super._init(newNom, newDescription, newOperateur, newStatsAffectees, newTypeCible, "activeCapacite")

