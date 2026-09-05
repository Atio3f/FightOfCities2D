extends RefCounted
class_name RarityData
## Sort of interface used to stock data for a reward

var id: String      # "COMMON", "RARE", etc.
var weight: int     # Weight use for proba
var type: String    # "UNIT", "EQUIPMENT", etc.
var color: Color    # Border color reward
var price: int      # Default price

func _init(_id: String, _weight: int, _type: String, _color: Color, _price: int = 0):
	self.id = _id
	self.weight = _weight
	self.type = _type
	self.color = _color
	self.price = _price
