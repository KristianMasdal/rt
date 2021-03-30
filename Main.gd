extends Node2D

var board = preload("res://World/Board.tscn")
var controller = preload("res://Player/Controller/Controller.tscn")
func _ready():
	init_game()
	

func init_game():
	print("Initializing...")
	var iBoard = board.instance()
	var iController = controller.instance()
	add_child(iBoard)
	add_child(iController)
	
	iController.connect("click", iBoard, "_on_click")
	iController.connect("destination_click", iBoard, "_on_destination_click")
	iController.connect("validate_moves", iBoard, "_on_validate_moves")
	iBoard.connect("moves_checked", iController, "_on_valid_moves_received")
	iBoard.connect("player_unit_selected", iController, "_on_player_unit_selected")
	
	
