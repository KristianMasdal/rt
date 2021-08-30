extends Node2D


var pos: Vector2
var type
var unit
func _ready():
	#print(pos," - t: ", type)
	
	#$Label.text = str(pos)
	if (unit != null):
		print(unit.type)
