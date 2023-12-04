extends Sprite2D

@onready var _animation_play = $AnimationPlayer
@onready var _timer = $Timer
@export var max_time = 10
@export var min_time = 5
var rng = RandomNumberGenerator.new()
func  _ready():
	_animation_play.animation_set_next("pisca", "idle")
	set_next_timeout()
	
func pisca() -> void:
	set_next_timeout()
	_animation_play.play("pisca")

func set_next_timeout():
	var interval = rng.randf_range(min_time, max_time)
	_timer.start(interval)	
