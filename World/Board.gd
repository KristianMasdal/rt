extends Node2D

var res_cell = preload("res://World/Cell.tscn")
var res_unit = preload("res://Common/BaseUnit.tscn")
var res_unit_player = preload("res://Player/PlayerUnit.tscn")
var res_unit_enemy = preload("res://Enemy/EnemyUnit.tscn")
var cells = []
var cell
var player_units = []
var enemy_units = []


##
# Signals
##
signal player_unit_selected

func _ready():
	init_board()
	for cell in cells:
		add_child(cell)
	var unit = res_unit_player.instance()
	randomize()
	var rand_num = 44#rand_range(0, 24)
	cells[rand_num].unit = unit
	cells[rand_num].unit.position = cells[rand_num].position
	var unitXpos = pixel_to_grid(cells[rand_num].position).x
	var unitYpos = pixel_to_grid(cells[rand_num].position).y
	player_units[unitXpos][unitYpos] = cells[rand_num].unit
	unit.gridPos = Vector2(unitXpos, unitYpos)
	unit.name = "Penguin"
	unit.actionDirections["SouthWest"] = true
	unit.actionDirections["SouthEast"] = true
	add_child(unit)
	
	unit = res_unit_player.instance()
	randomize()
	rand_num = 35#rand_range(0, 24)
	cells[rand_num].unit = unit
	cells[rand_num].unit.position = cells[rand_num].position
	unitXpos = pixel_to_grid(cells[rand_num].position).x
	unitYpos = pixel_to_grid(cells[rand_num].position).y
	player_units[unitXpos][unitYpos] = cells[rand_num].unit
	unit.gridPos = Vector2(unitXpos, unitYpos)
	unit.name = "Bear"
	unit.actionDirections["South"] = true
	add_child(unit)
	
	unit = res_unit_enemy.instance()
	randomize()
	rand_num = 24#rand_range(0, 24)
	cells[rand_num].unit = unit
	cells[rand_num].unit.position = cells[rand_num].position
	unitXpos = pixel_to_grid(cells[rand_num].position).x
	unitYpos = pixel_to_grid(cells[rand_num].position).y
	enemy_units[unitXpos][unitYpos] = cells[rand_num].unit
	unit.gridPos = Vector2(unitXpos, unitYpos)
	unit.name = "Rhino"
	add_child(unit)
	
	
	
	for u in player_units:
		if (u != null):
			for uu in u:
				if (uu != null):
					print("wow! ", pixel_to_grid(uu.position))
	
func determine_cell_type(tileArray, x, y):
	randomize()
	var chosenTile
	var randomNum = rand_range(0.1, 1.0)
	cell = res_cell.instance()
	cell.pos = Vector2(x,y)
	cell.position = grid_to_pixel(cell.pos)
	if ((randomNum < 0.2) && (y > 0 && y < 9)):
		chosenTile = tileArray[1]
		cell.type = "bad"
	elif ((randomNum > 0.9) && (y > 0 && y < 9)):
		cell.type = "good"
		chosenTile = tileArray[2]
	else:
		cell.type = "neutral"
		chosenTile = tileArray[0]
	cells.append(cell)
	return chosenTile
	
func _process(delta):
	pass
#	if (Input.is_action_just_pressed("click")):
#		print("global pos: ", get_global_mouse_position())
#		print("local pos: ", get_local_mouse_position())
#		print("grid pos: ", pixel_to_grid(get_global_mouse_position()))


func init_board():
	var tile_dark = $Grid.tile_set.find_tile_by_name("dark")
	var tile_dark_orange = $Grid.tile_set.find_tile_by_name("dark_orange")
	var tile_dark_green = $Grid.tile_set.find_tile_by_name("dark_green")
	var dark = [tile_dark, tile_dark_orange, tile_dark_green]
	var tile_light = $Grid.tile_set.find_tile_by_name("light")
	var tile_light_orange = $Grid.tile_set.find_tile_by_name("light_orange")
	var tile_light_green = $Grid.tile_set.find_tile_by_name("light_green")
	var light = [tile_light, tile_light_orange, tile_light_green]
	init_units()
	for i in 10:
		for j in 10:
			if (i % 2 == 0 && j % 2 != 0 || i % 2 != 0 && j % 2 == 0):
				$Grid.set_cell(i, j, determine_cell_type(dark, i, j))
			else:
				$Grid.set_cell(i, j, determine_cell_type(light, i, j))

func init_units():
	for i in 10:
		var j = []
		j.resize(10)
		player_units.append(j)
	for i in 10:
		var j = []
		j.resize(10)
		enemy_units.append(j)

func handle_player_unit_clicked(pos):
	var unit = player_units[pos.x][pos.y]
	emit_signal("player_unit_selected", unit)



##
# RECIEVERS
#
func on_click(pos: Vector2):
	if (player_units[pos.x][pos.y] != null):
		handle_player_unit_clicked(pos)

func on_destination_click(from: Vector2, to: Vector2):
	print("from:", from, "to: ", to)
	var unitToMove = player_units[from.x][from.y]
	print(unitToMove.name, " will be moved")
	unitToMove.position = grid_to_pixel(to)
	unitToMove.gridPos = to
	player_units[to.x][to.y] = unitToMove
	player_units[from.x][from.y] = null
	
func on_validate_moves(moves):
	var validMoves = []
	var invalidDirections = []
	for move in moves:
		print("Validating move: ", pixel_to_grid(move.position), move.direction)
		if !invalidDirections.has(move.direction):
			if is_instance_valid(move):
				var pos = pixel_to_grid(move.position)
				if (pos.x < 10 && pos.x >= 0 && pos.y <= 9 && pos.y >= 0 && player_units[pos.x][pos.y] == null && enemy_units[pos.x][pos.y] == null):
					validMoves.append(move)
					print("move VALID: ", pixel_to_grid(move.position), move.direction)
				else:
					invalidDirections.append(move.direction)
					print("move NOT VALID: ", pixel_to_grid(move.position), move.direction)
	return validMoves


##
# Coord transformations
##
func pixel_to_grid(pos: Vector2):
	return Vector2(int(pos.x/64), int(pos.y/64))

func grid_to_pixel(pos: Vector2):
	return Vector2(pos.x*64+28, pos.y*64+28)

func true_pos(pos):
	return Vector2(pos.x/2, pos.y/2)
