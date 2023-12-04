extends "res://Scripts/Creature.gd"

@export var jump_force : float = 1
@export var jump_multiplier : float = 2
@export var dash_force : float = 3
@export var dash_duration : float = 0.125
@export var max_climbs : int = 3
@export var throw_force : float = 400
@onready var _animation_player = $AnimationPlayer
@onready var _sprite = $Sprite
@onready var _interaction_area = $Interaction_area
@onready var _climb_ray = $Climb_detector
var jump_direction = Vector2.UP

var motion_direction : float = 0

var is_dashing = false
var can_dash = false
var dash_timer = dash_duration

var is_climbing = false
var can_climb = false
var climb_count = 0

var in_range_trashes = []
var in_range_items = []

var inventory = Inventory.new()
var max_gravity = gravity
var max_jump_force = jump_force
	
func _process(delta):
	if is_dashing:
		dash_timer -= delta
	if dash_timer < 0:
		stop_dash()
		
	if velocity == Vector2.ZERO and not is_climbing:
		_animation_player.play("idle")
	
	if position.y > 500:
		position = Vector2.ZERO
		
	if is_climbing and not can_climb:
		stop_climbing()
	

func jump() -> void:
	if not is_dashing:
		if is_on_floor() and not is_climbing: 
			_animation_player.play("air")
			add_to_movement_direction(jump_direction*jump_force*jump_multiplier)
		elif is_climbing and climb_count < max_climbs:
			climb_count += 1
			print("aaa")
			_animation_player.play("climb")
			add_to_movement_direction(jump_direction*jump_force)

func low_jump():
	if is_on_floor() and not is_dashing: 
		_animation_player.play("air")
		add_to_movement_direction(jump_direction*jump_force)

func turn(direction: float) -> void:
	if direction != 0:
		_interaction_area.scale.x = direction
		_climb_ray.scale.x = direction
		_sprite.scale.x = direction

func horizontal_move(direction: float) -> void:
	turn(direction)
	if not is_dashing:
		if is_on_floor() and velocity.x != 0:
			_animation_player.play("walk")
		elif direction != 0 and not is_climbing and can_climb:
			start_climbing()
		elif is_climbing and (direction == 0 or is_on_floor()):
			stop_climbing()
		motion_direction = direction
		set_x_velocity(direction)

func start_climbing() -> void:
	if is_on_floor():
		return
	is_climbing = true	
	_animation_player.play("climb")
	velocity = Vector2.ZERO
	gravity = 2
	jump_force = 0.8
	
func stop_climbing() -> void:
	_sprite.offset = Vector2.ZERO
	if is_on_floor():
		_animation_player.play("idle")
	else:
		_animation_player.play("air")
	is_climbing = false
	gravity = max_gravity
	jump_force = max_jump_force
	climb_count = 0
	
func attack() -> void:
	var bodies = _interaction_area.get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		if body is PhysicsBody2D:
			var b = body as RigidBody2D
			var throw_direction = (b.position - position).normalized()
			print(throw_direction)
			b.apply_central_impulse(throw_direction*throw_force)
func _on_touch_wall(body) ->void:
	can_climb = true

func _on_leave_wall(body) -> void:
	can_climb = false
	
func dash() -> void:
	if can_dash and not is_dashing and motion_direction != 0:
		_animation_player.play("air")
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
	if _animation_player.current_animation == "":
		_animation_player.play("idle")
	can_dash = true
	
func die() -> void:
	super.die()

# Coleta o primeiro item que colidiu, ou então o primeiro lixo
func collect():
	if in_range_items != []:
		inventory.add_item(in_range_items[0].get_item_name())
		in_range_items[0].queue_free()
		in_range_items.pop_front()
		inventory.debug()
	elif in_range_trashes != []:
		_animation_player.play("sniff") # Adicionar animation lock
		print(_animation_player.current_animation)
		in_range_trashes[0].rummage() # Função pro lixo dropar itens
		in_range_trashes.pop_front()

# Entrou em um novo lixo
func append_trash(body: Node2D) -> void:
	if body.is_in_group("trash"):
		in_range_trashes.append(body)

# Saiu de um lixo
func leave_trash(body: Node2D) -> void:
	if body.is_in_group("trash") and in_range_trashes.has(body):
		in_range_trashes.erase(body)

# Colidiu com item
func join_item(body: Node2D) -> void:
	if body.is_in_group("item"):
		in_range_items.append(body)

# Saiu da colisão com item
func leave_item(body: Node2D) -> void:
	if body.is_in_group("item") and in_range_items.has(body):
		in_range_items.erase(body)
