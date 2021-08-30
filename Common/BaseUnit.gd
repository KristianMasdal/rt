extends Node2D


export var hp: int
export var movement: int
export var atk: int
export var posX: int
export var posY: int
export var actionDirections = {
	"North": false, 
	"NorthEast": false,
	"East": false,
	"SouthEast": false,
	"South": false,
	"SouthWest": false,
	"West": false,
	"NorthWest": false,
}
var gridPos: Vector2
var type = "Penguin"

func _ready():
	pass # Replace with function body.

