# inventory.gd
extends Node

var items: Dictionary = {}  # { "Stone": 3, "Sword": 1 }

signal inventory_updated

func add_item(item_data: Dictionary) -> bool:
	var item_name = item_data.get("name", "Unknown")
	if items.has(item_name):
		items[item_name]["count"] += 1
	else:
		items[item_name] = item_data.duplicate()
		items[item_name]["count"] = 1
	emit_signal("inventory_updated")
	return true

func remove_item(item_name: String) -> void:
	if items.has(item_name):
		items[item_name]["count"] -= 1
		if items[item_name]["count"] <= 0:
			items.erase(item_name)
		emit_signal("inventory_updated")
