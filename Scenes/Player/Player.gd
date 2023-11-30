extends "res://Scripts/Creature.gd"

@export var jump_force : float = 3.5
@export var dash_force : float = 5
@export var dash_duration : float = 0.25

@onready var _animation_player = $AnimationPlayer

var jump_direction = Vector2.UP

var motion_direction : float = 0

var is_dashing = false
var can_dash = false
var dash_timer = dash_duration

func _process(delta):
	if is_dashing:
		dash_timer -= delta
	if dash_timer < 0:
		stop_dash()
		
	if velocity == Vector2.ZERO:
		_animation_player.play("idle")
	if position.y > 500:
		position = Vector2.ZERO
	

func jump() -> void:
	if is_on_floor() and not is_dashing: 
		add_to_movement_direction(jump_direction*jump_force)
		
func horizontal_move(direction: float) -> void:
	if not is_dashing:
		_animation_player.play("walk")
		motion_direction = direction
		set_x_velocity(direction)
	
func dash() -> void:
	if can_dash and not is_dashing and motion_direction != 0:
		is_dashing = true
		can_dash = false
		is_affected_by_gravity = false
		var direction = Vector2(motion_direction, 0).normalized()
		set_movement_direction(direction*dash_force)

func stop_dash() -> void:
	is_affected_by_gravity = true
	dash_timer = dash_duration
	is_dashing = false
	set_movement_direction(Vector2.ZERO)
	
func _on_floor_hit() -> void:
	can_dash = true
	
func die() -> void:
	super.die()
