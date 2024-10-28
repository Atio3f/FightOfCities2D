extends Resource
class_name carteRessource

@export_enum("Unite", "Batiment", "Objet", "Sort","Unknow")var typeCarte : String		#Permet de déterminer si c'est une unité ou un bâtiment


@export var nom : String	#Le nom de l'unité
@export var description : String	#Description détaillée de l'unité(blague ou truc sérieux à toi de voir !)

@export var couleurEquipe : String 	#Permet d'indiquer l'équipe de l'unité
