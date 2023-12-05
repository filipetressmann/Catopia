extends RigidBody2D

const items = ["metal", "glass", "wood", "string", "nail", "bone", "rock"]

var id = 0

# Called when the node enters the scene tree for the first time.
func set_random() -> void:
	self.id = randi() % items.size()
	$Sprite.frame = id

func set_id(id: int) -> void:
	self.id = (id % items.size())
	$Sprite.frame = id

func get_item_name():
	return items[id]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.join_item(self)


func _on_body_exited(body):
	if body.is_in_group("player"):
		body.leave_item(self)
