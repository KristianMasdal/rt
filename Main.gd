extends Node2D

var board = preload("res://World/Board.tscn")
var controller = preload("res://Player/Controller/Controller.tscn")
var iBoard
var iController
func _ready():
	init_game()
	

func init_game():
	print("Initializing...")
	iBoard = board.instance()
	iController = controller.instance()
	add_child(iBoard)
	add_child(iController)
	iController.connect("click", self, "_board_clicked")
	iController.connect("destination_click", self, "_on_destination_click")
	iController.connect("move_pattern_selected", self, "_on_validate_moves")
	iBoard.connect("player_unit_selected", self, "_on_player_unit_selected")


##
# Receivers
#

func _board_clicked(pos: Vector2):
	iBoard.on_click(pos)
func _on_destination_click(from: Vector2, to: Vector2):
	iBoard.on_destination_click(from, to)
	
func _on_validate_moves(moves):
	var validMoves = iBoard.on_validate_moves(moves)
	iController.on_valid_moves_received(validMoves)
func _on_player_unit_selected(unit):
	iController.on_player_unit_selected(unit)
