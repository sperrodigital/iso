extends Node

signal inventory_changed

var items: Dictionary = {}

func add_item(item_name: String, amount: int = 1) -> void:
	if item_name in items:
		items[item_name] += amount
	else:
		items[item_name] = amount
	inventory_changed.emit()

func get_item(item_name: String) -> int:
	return items.get(item_name, 0)
