# inventory_ui.gd
extends CanvasLayer

@onready var items_container = $Panel/VBoxContainer

func _ready():
	Inventory.inventory_updated.connect(_refresh)

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		visible = !visible

func _refresh():
	for child in items_container.get_children():
		child.queue_free()
	for item_name in Inventory.items:
		var count = Inventory.items[item_name]["count"]
		var label = Label.new()
		label.text = item_name + " x" + str(count)
		label.add_theme_font_size_override("font_size", 10)
		items_container.add_child(label)
