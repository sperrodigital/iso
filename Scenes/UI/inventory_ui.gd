# inventory_ui.gd
extends CanvasLayer

@onready var items_container: GridContainer = $GridContainer

const SlotUI = preload("res://Singleton/Inventory/slot_ui.tscn")
var slots: Array = []

func _ready():
	Inventory.inventory_updated.connect(_refresh)
	_refresh()

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		visible = !visible

func _refresh():
	for child in items_container.get_children():
		child.queue_free()
		
	for i in Inventory.SLOT_COUNT:
		var slot = SlotUI.instantiate()
		slot.slot_index = i
		items_container.add_child(slot)
		
		if Inventory.slots[i] != null:
			var data = Inventory.slots[i]
			slot.setup(data["item_name"], data["count"], data.get("icon", null))
		else:
			slot.setup("", 0)
