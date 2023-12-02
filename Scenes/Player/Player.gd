extends "res://Scripts/Creature.gd"

@export var jump_force : float = 1.5
@export var jump_multiplier : float = 5.0 
@export var dash_force : float = 5
@export var dash_duration : float = 0.25

@onready var _animation_player = $AnimationPlayer
@onready var _sprite = $Sprite

var jump_direction = Vector2.UP

var motion_direction : float = 0

var is_dashing = false
var can_dash = false
var dash_timer = dash_duration

var in_range_trashes = []
var in_range_items = []

var inventory = Inventory.new()

func _process(delta):
	if is_dashing:
		dash_timer -= delta
	if dash_timer < 0:
		stop_dash()
		
	if velocity == Vector2.ZERO:
		_animation_player.play("idle")
	elif velocity.x < 0:
		_sprite.scale.x = -1
	elif velocity.x > 0:
		_sprite.scale.x = 1
	
	if position.y > 500:
		position = Vector2.ZERO
	

func jump() -> void:
	if is_on_floor() and not is_dashing: 
		_animation_player.play("air")
		add_to_movement_direction(jump_direction*jump_force*jump_multiplier)

func low_jump():
	if is_on_floor() and not is_dashing: 
		_animation_player.play("air")
		add_to_movement_direction(jump_direction*jump_force)

func horizontal_move(direction: float) -> void:
	if not is_dashing:
		_animation_player.play("run")
		motion_direction = direction
		set_x_velocity(direction)
	
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
