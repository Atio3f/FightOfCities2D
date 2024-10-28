extends Path2D
class_name carte

var nom : String
var description : String	#String contenant la description de l'unité(voir ressourceUnite)

@export_enum("Unite", "Batiment", "Objet", "Unknow")var typeCarte : String = "Unknow"
