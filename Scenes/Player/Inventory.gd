class_name Inventory

var _items = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_item(item_name: String, amount: int = 1) -> void:
	if _items.has(item_name):
		_items[item_name] += amount
	else:
		_items[item_name] = amount

func consume_item(item_name: String, amount: int = 1) -> bool:
	if _items.has(item_name):
		if _items[item_name] >= amount:
			_items[item_name] -= amount
			return true
	return false

func debug() -> void:
	print(_items)
