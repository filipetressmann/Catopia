extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Animation.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func body_submerged(body) -> void:
	if body.is_in_group("player"):
		body.respawn()
	elif body.is_in_group("drop"):
		body.queue_free()
