extends Node2D

signal click
signal destination_click
signal validate_moves

const gp = 28

var indicator_move = preload("res://Common/IndicatorMove.tscn")
var indicator = preload("res://Common/Indicator.tscn")
var moveIndicator 
var selectedUnit
var movementIndicator
var indicatorParent
var movesToValidate
var validatedMoves


func _ready():
	pass
	
func _process(delta):
	if (Input.is_action_just_pressed("click")):
		handle_left_click()
	if (Input.is_action_just_pressed("right_click")):
		handle_right_click()
		
func handle_left_click():
	var mPos = p_to_g(get_global_mouse_position())
	if (indicatorParent == null):
		emit_signal("click", mPos)
	else:
		if (mPos == selectedUnit.gridPos):
			remove_indicators()
		else:
			check_valid_move(mPos)

func handle_right_click():
	if(indicatorParent != null):
		remove_indicators()	


func check_valid_move(mPos: Vector2):
	print("controller wants unit to move to ", mPos)
	var indicators: Array = get_indicators()
	var validMove = indicators.find(mPos)
	if (validMove != -1):
		emit_signal("destination_click", selectedUnit.gridPos, indicators[validMove])
		remove_indicators()
		selectedUnit = null


func get_indicators():
	var indicators = []
	for c in indicatorParent.get_children():
		if (c.is_in_group("indicator")):
			indicators.append(p_to_g(c.position))
	return indicators
	
func remove_indicators():
	selectedUnit.get_node("AnimationPlayer").play("Idle")
	selectedUnit.get_node("Sprite").set_rotation(0)
	for c in indicatorParent.get_children():
		if (c.is_in_group("indicator")):
			c.queue_free()
	indicatorParent.queue_free()
	
func p_to_g(pos: Vector2):
	return Vector2(int(pos.x/64), int(pos.y/64))

func grid_to_pixel(pos: Vector2):
	return Vector2(pos.x*64, pos.y*64)

func true_pos(pos):
	return Vector2(pos.x/2, pos.y/2)



##
# EMITTERS
##


##
# RECIEVERS
##


func _on_valid_moves_received(moves):
	validatedMoves = moves
	for move in validatedMoves:
		indicatorParent.add_child(move)
		#print(get_children())
		#move.add_child(move)
	add_child(indicatorParent)
	
func _on_player_unit_selected(unit):
	movesToValidate = []
	selectedUnit = unit
	selectedUnit.get_node("AnimationPlayer").play("Selected")
	indicatorParent = indicator.instance()
	indicatorParent.name = "IndicatorParent"
	indicatorParent.add_to_group("indicator")
	for i in 5:
		var m = indicator_move.instance()
		m.add_to_group("indicator")
		m.position = gridUp(unit.gridPos, i)
		#indicatorParent.add_child(m)
		movesToValidate.append(m)
		#add_child(indicatorParent)
	for i in 5:
		var m = indicator_move.instance()
		m.add_to_group("indicator")
		m.position = gridDown(unit.gridPos, i)
		#indicatorParent.add_child(m)
		movesToValidate.append(m)
	for i in 5:
		var m = indicator_move.instance()
		m.add_to_group("indicator")
		m.position = gridLeft(unit.gridPos, i)
		#indicatorParent.add_child(m)
		movesToValidate.append(m)
	for i in 5:
		var m = indicator_move.instance()
		m.add_to_group("indicator")
		m.position = gridRight(unit.gridPos, i)
		#indicatorParent.add_child(m)
		movesToValidate.append(m)
	emit_signal("validate_moves", movesToValidate)
func gridRight(pos: Vector2, i: int):
	return Vector2(pos.x*64+64*i+64, pos.y*64)

func gridLeft(pos: Vector2, i: int):
	return Vector2(pos.x*64-64*i-64, pos.y*64)

func gridUp(pos: Vector2, i: int):
	return Vector2(pos.x*64, pos.y*64+64*i+64)

func gridDown(pos: Vector2, i: int):
	return Vector2(pos.x*64, pos.y*64-64*i-64)
