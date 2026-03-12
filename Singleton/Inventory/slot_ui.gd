extends Panel

@onready var icon_rect: TextureRect = $TextureRect
@onready var count_label: Label = $Label

var item_name: String = ""
var count: int = 0

# Dragging
var slot_index: int = -1

func _ready():
	add_theme_font_size_override("font_size", 7)

func setup(p_item_name: String, p_count: int, p_icon: Texture2D = null):
	item_name = p_item_name
	count = p_count
	
	if p_count > 0:
		count_label.text = str(p_count)
		count_label.visible = true
	else:
		count_label.visible = false
		
	if p_icon != null:
		icon_rect.texture = p_icon
	else:
		icon_rect.texture = null

func _get_tooltip(at_position: Vector2) -> String:
	if item_name == "":
		return ""
	return item_name

func _get_drag_data(at_position: Vector2):
	# Don't allow dragging empty slots
	if item_name == "":
		return
	
	# Build a preview that follows the cursor
	var preview = TextureRect.new()
	preview.texture = icon_rect.texture
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.custom_minimum_size = Vector2(16,16)
	set_drag_preview(preview)
	
	# This payload gets passed to _drop_data on the target slot
	return { "item_name": item_name, "count": count, "source_slot": self }
	
func _can_drop_data(at_position: Vector2, data) -> bool:
	# Accept the drop if the data looks like an item
	return data is Dictionary and data.has("item_name")
	
func _drop_data(at_position: Vector2, data):
	var source_index = data["source_slot"].slot_index
	
	# Swap in the data model
	var temp = Inventory.slots[slot_index]
	Inventory.slots[slot_index] = Inventory.slots[source_index]
	Inventory.slots[source_index] = temp
	
	#Redraw from the source of truth
	Inventory.inventory_updated.emit()
