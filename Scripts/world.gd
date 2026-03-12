extends Node2D

@onready var menu: Control = $CanvasLayer/Menu
@onready var dim: ColorRect = $CanvasLayer/ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	menu.hide()
	dim.hide()
	menu.menu_closed.connect(_on_menu_closed)
	
	if SaveManager.pending_load_slot >= 0:
		var player = get_tree().get_first_node_in_group("player")
		SaveManager.load_game(SaveManager.pending_load_slot, player)
		SaveManager.pending_load_slot = -1
	
func _on_menu_closed():
	print("Closing menu...")
	dim.hide()

func _input(event):
	if event.is_action_pressed("pause"):
		print("Pausing game...")
		if menu.visible:
			menu.hide()
			dim.hide()
			get_tree().paused = false
		else:
			print("Showing menu")
			menu.show()
			dim.show()
			get_tree().paused = true
			get_viewport().set_input_as_handled()
