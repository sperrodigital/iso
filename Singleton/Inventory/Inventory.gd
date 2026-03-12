# inventory.gd
extends Node

const SLOT_COUNT = 10
var slots: Array = []

signal inventory_updated

func _ready():
	slots.resize(SLOT_COUNT)

func add_item(item: Dictionary):
	var item_name = item["name"]
	var count = item.get("value", 1)
	var icon = item.get("icon", null)
	
	# If item already exists anywhere, stack it
	for i in SLOT_COUNT:
		if slots[i] != null and slots[i]["item_name"] == item_name:
			slots[i]["count"] += count
			inventory_updated.emit()
			return true
	
	# Otherwise find the first empty slot
	for i in SLOT_COUNT:
		if slots[i] == null:
			slots[i] = { "item_name": item_name, "count": count, "icon": icon }
			inventory_updated.emit()
			return true
