extends Area2D

@onready var _sprite = $Sprite

const items = ["metal", "glass", "wood", "string", "nail", "bone", "rock"]

var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.id = randi() % items.size()
	_sprite.frame = id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_item_name():
	return items[id]




func _on_body_entered(body):
	if body.is_in_group("player"):
		body.join_item(self)


func _on_body_exited(body):
	if body.is_in_group("player"):
		body.leave_item(self)
