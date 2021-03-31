extends "res://Common/BaseUnit.gd"

export var sprite: Texture

func _ready():
	$Sprite.texture = sprite
	$AnimationPlayer.play("Idle")
