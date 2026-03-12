extends Control

@onready var main_menu: Control = $"."
@onready var settings_menu: CanvasLayer = $"Settings Menu"

# Refs to sliders/buttons inside settings menu
@onready var full_screen_control: CheckButton = $"Settings Menu/Panel/VBoxContainer/FullScreenControl"


func _ready():
	main_menu.visible = true
	settings_menu.visible = false


func _on_start_pressed():
	# Start the game
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_load_pressed():
	# Load a saved game
	pass # Hook up to save/load system UI.


func _on_settings_pressed():
	# Open hidden Settings Menu
	print("Settings pressed...")
	# Sync UI to current saved values in config
	
	main_menu.visible = false
	settings_menu.visible = true

func _on_quit_pressed():
	# Quit game
	get_tree().quit()

func _on_back_pressed():
	# Back to main menu - from settings menu
	main_menu.visible = true
	settings_menu.visible = false
