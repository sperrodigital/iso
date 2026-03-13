# inventory.gd
extends Node

const ITEM_DATABASE = {
	"Stone": "res://Tileset/Split/tile_06Wheat7.png",
	"Wood": "res://Tileset/Split/tile_048.png",
	"Cloth": "res://Tileset/Split/tile_045.png",
	"wheat": "res://Assets/Resources/Wheat.png"
}

const SLOT_COUNT = 10
var slots: Array = []

signal inventory_updated

func _ready():
	slots.resize(SLOT_COUNT)
	for i in SLOT_COUNT:
		slots[i] = null

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

# Helper to get textures for inventory images when loading them from a save file
func get_icon(item_name: String) -> Texture2D:
	if ITEM_DATABASE.has(item_name):
		return load(ITEM_DATABASE[item_name])
	return null
