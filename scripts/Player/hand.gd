##La main d'un l'unité ainsi que son deck et sa défausse
extends Resource
class_name mainJoueur


var hand : Array = []	#Contient les cartes dans la main du joueur
static var tailleMainMax : int = 8	#On ne peut avoir que 8 cartes au maximum dans sa main
var deck : Array = []	#Contient toutes les cartes restantes du deck du joueur
var defausse : Array = []	#Contient toutes les unités, bâtiments et sorts utilisés


##Permet de visionner les nbrCartes cartes dans le deck
func visionnerDeck(nbrCartes : int):
	return deck.slice(0, nbrCartes)	#Renvoie nbrCartes cartes sur le dessus du deck du joueur

##Permet de visionner les nbrCartes cartes dans la main
func visionnerMain(nbrCartes : int) -> Array:
	hand.shuffle()		#On mélange la main avant pour faire de l'aléatoire à changer si jamais on permet au joueur de choisir
	return hand.slice(0, nbrCartes)

##Fonction appelée lorsque le joueur a besoin de piocher une ou plusieurs cartes du dessus de son deck, renvoie si l'action a réussi entièrement
func piocher(nbrCartes : int, condition : String) -> bool:
	var cartesPiochees : Array = []
	var vide : bool = false	#Vérifie si le bon nombre de carte a pu être pioché
	var cartePioche : unite 
	for i in range(0, nbrCartes, 1) :
		cartePioche = deck.pop_front()	#Moins optimisé que pop_back d'après ce qu'ils disent à voir
		if(cartePioche == null) :
			vide = true
			break#On sort de la boucle si il n'y a plus de carte dans le deck
		else :
			cartesPiochees.append(cartePioche)
	hand += cartesPiochees
	return vide

##Fonction appelée lorsque le joueur a besoin de piocher une ou plusieurs cartes de manière random, renvoie si l'action a réussi entièrement
func piocherRandom(nbrCartes : int, condition : String) -> bool:
	var cartesPiochees : Array = []
	var vide : bool = false	#Vérifie si le bon nombre de carte a pu être pioché
	var cartePioche : unite 
	for i in range(0, nbrCartes, 1) :
		cartePioche = deck.pick_random()
		if(cartePioche == null) :
			vide = true
			break#On sort de la boucle si il n'y a plus de carte dans le deck
		else :
			cartesPiochees.append(cartePioche)
			deck.erase(cartePioche)
	hand += cartesPiochees
	return vide

##Permet de mélanger le deck
func melangerDeck():
	deck.shuffle()

##Met la défausse du joueur dans le deck avant de le reset
func remelangerDefausse():
	deck += defausse
	defausse = []
	

##Ajoute une ou plusieurs cartes à la main du joueur
func ajouterCartesMain(cartesAjoutees : Array) -> void:
	hand += cartesAjoutees
	

##Ajoute une ou plusieurs cartes à la défausse du joueur
func ajouterCartesDefausse(cartesAjoutees : Array) -> void:
	defausse += cartesAjoutees


##Ajoute une ou plusieurs cartes au deck du joueur
func ajouterCartesDeck(cartesAjoutees : Array) -> void:
	deck += cartesAjoutees
	melangerDeck()	#On le remélange après ça
