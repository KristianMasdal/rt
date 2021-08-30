extends "res://Common/BaseUnit.gd"

export var sprite: Texture

var actionIndicator = preload("res://Common/Action.tscn")

var north
var east 
var south 
var west
func _ready():
	var extraPadding = 5
	
	north = posY-32
	east = posX+extraPadding+36
	south = posY+40
	west = posX-32
	$Sprite.texture = sprite
	$AnimationPlayer.play("Idle")

	if self.actionDirections["North"] == true:
		var actionNorth = actionIndicator.instance()
		add_child(actionNorth)
		actionNorth.position = Vector2(posX+extraPadding, north)
	if self.actionDirections["NorthEast"] == true:
		var actionNorthEast = actionIndicator.instance()
		add_child(actionNorthEast)
		actionNorthEast.position = Vector2(east, north)
	if self.actionDirections["East"] == true:
		var actionEast = actionIndicator.instance()
		actionEast.position  = Vector2(east, posY+extraPadding)
		add_child(actionEast)
	if self.actionDirections["SouthEast"] == true:
		var actionSouthEast = actionIndicator.instance()
		add_child(actionSouthEast)
		actionSouthEast.position = Vector2(east, south)
	if self.actionDirections["South"] == true:
		var actionSouth = actionIndicator.instance()
		add_child(actionSouth)
		actionSouth.position = Vector2(posX+extraPadding, south)
	if self.actionDirections["SouthWest"] == true:
		var actionSouthWest = actionIndicator.instance()
		add_child(actionSouthWest)
		actionSouthWest.position = Vector2(west, south)
	if self.actionDirections["West"] == true:
		var actionWest = actionIndicator.instance()
		add_child(actionWest)
		actionWest.position  = Vector2(west, posY+extraPadding)
	if self.actionDirections["NorthWest"] == true:
		var actionNorthWest = actionIndicator.instance()
		add_child(actionNorthWest)
		actionNorthWest.position = Vector2(west, north)
