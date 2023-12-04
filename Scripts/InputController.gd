extends Node

signal jump
signal low_jump
signal horizontal_move(direction: float)
signal dash
signal collect
signal fire1
var horizontal_axis : float  = 0

func _process(delta):
	process_input()
	
func process_input() -> void:
	var current_horizontal_axis = Input.get_axis("Left", "Right")
	horizontal_move.emit(current_horizontal_axis)		
	
func _input(event):
	var direction_vector = Vector2.ZERO
	if event.is_action_pressed("Jump"):
		jump.emit()	
	if event.is_action_pressed("LowJump"):
		low_jump.emit()	
	if event.is_action_pressed("Dash"):
		dash.emit()
	if event.is_action_pressed("Collect"):
		collect.emit()
	if event.is_action_pressed("Fire1"):
		fire1.emit()
