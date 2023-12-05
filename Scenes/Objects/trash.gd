extends Area2D

@onready var sprite = $Sprite
@onready var drop = preload("res://Scenes/Objects/drop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.frame = randi() % 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func rummage():
	var loot = drop.instantiate()
	loot.set_random()
	loot.position = position
	
	get_parent().add_child(loot)
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.append_trash(self)


func _on_body_exited(body):
	if body.is_in_group("player"):
		body.leave_trash(self)
