##Capacités liées aux kills effectués par l'unité
extends capacite
class_name killCapacite

@export_range(-1, 50) var limiteUtilisation : int		#Indique le nombre d'utilisations maximales de la capacité, -1 si la capacité n'a pas de limite
@export_range(-1, 50) var utilisationsRestantes : int		#Indique le nombre d'utilisations restantes de la capacité, -1 si la capacité n'a pas de limite
