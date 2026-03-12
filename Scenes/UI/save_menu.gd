class_name SaveMenu extends CanvasLayer

var mode: Menu.SaveMode

@onready var slots = [
	$Panel/VBoxContainer/Slot1,
	$Panel/VBoxContainer/Slot2,
	$Panel/VBoxContainer/Slot3,
]

signal	save_completed

func setup(m: Menu.SaveMode):
	mode = m
	_refresh_slots()
	# Connect slots in code instead of editor
	for i in slots.size():
		if not slots[i].pressed.is_connected(_on_slot_pressed):
			slots[i].pressed.connect(_on_slot_pressed.bind(i))
			
func _refresh_slots():
	for i in SaveManager.SLOT_COUNT:
		var timestamp = SaveManager.get_slot_time(i)
		slots[i].text = "Slot %d — %s" % [i, timestamp if timestamp else "Empty"]

func _on_slot_pressed(slot: int):
	if mode == Menu.SaveMode.SAVE:
		var player = get_tree().get_first_node_in_group("player")
		SaveManager.save_game(slot, player)
		save_completed.emit()
		visible = false
	else:
		# Store the slot and load after scene change
		SaveManager.pending_load_slot = slot
		get_tree().change_scene_to_file("res://Scenes/world.tscn")
