extends Node

signal jump
signal low_jump
signal horizontal_move(direction: float)
signal dash

var horizontal_axis : float  = 0

func _process(delta):
	process_input()
	
func process_input() -> void:
	var current_horizontal_axis = Input.get_axis("Left", "Right")
	if current_horizontal_axis != horizontal_axis:
		horizontal_axis = current_horizontal_axis
		horizontal_move.emit(horizontal_axis)		
	
func _input(event):
	var direction_vector = Vector2.ZERO
	if event.is_action_pressed("Jump"):
		jump.emit()	
	if event.is_action_pressed("LowJump"):
		low_jump.emit()	
	if event.is_action_pressed("Dash"):
		dash.emit()
