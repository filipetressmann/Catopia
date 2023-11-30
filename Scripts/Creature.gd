extends CharacterBody2D

signal damage_taken
signal died
signal collision_detected(collision : KinematicCollision2D)

@export var max_life : int = 0
@export var atack_rating : int = 0
@export var speed : int = 0
@export var is_affected_by_gravity : bool = true
var gravity : float = 20
var friction : float = 0.99

var current_life : int = max_life

func take_damage(damage : int) -> void:
	current_life -= damage
	damage_taken.emit()
	if current_life <= 0:
		current_life = 0
		die()
		
func set_movement_direction(direction: Vector2) -> void:
	velocity = direction*speed

func add_to_movement_direction(direction: Vector2) -> void:
	velocity += direction*speed

func set_x_velocity(direction: float) -> void:
	velocity.x = direction*speed
	
func die() -> void:
	died.emit()

func _physics_process(delta):
	if not is_on_floor() and is_affected_by_gravity:
		velocity += Vector2.DOWN*gravity
	move_and_slide()		
