extends Control

class_name Menu

enum Mode { MAIN_MENU, PAUSE }
enum SaveMode { SAVE, LOAD }

@export var mode: Mode = Mode.MAIN_MENU
@onready var menu_music: AudioStreamPlayer = $MenuMusic

@onready var main_menu: Control = $"."
@onready var settings_menu: CanvasLayer = $"Settings Menu"
@onready var save_menu: CanvasLayer = $"Save Menu"
@onready var full_screen_control: CheckButton = $"Settings Menu/Panel/VBoxContainer/FullScreenControl"
@onready var resume_btn: Button = $VBoxContainer/Resume
@onready var start_btn: Button = $VBoxContainer/Start
@onready var save_btn: Button = $VBoxContainer/Save

signal menu_closed

func _ready():
	if GameState.is_main_menu():
		menu_music.play()
	main_menu.visible = true
	settings_menu.visible = false
	save_menu.visible = false
	_apply_mode()
	
	# Connect to signal for once game is saved so we can close the menu
	save_menu.save_completed.connect(_on_resume_pressed)

func _apply_mode():
	resume_btn.visible = mode == Mode.PAUSE
	save_btn.visible = mode == Mode.PAUSE
	start_btn.visible = mode == Mode.MAIN_MENU

func _on_resume_pressed():
	menu_closed.emit()
	hide()
	get_tree().paused = false

func _on_start_pressed():
	GameState.set_state(GameState.State.PLAYING)
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_save_pressed():
	main_menu.visible = false
	save_menu.setup(SaveMode.SAVE)
	save_menu.visible = true

func _on_load_pressed():
	main_menu.visible = false
	save_menu.setup(SaveMode.LOAD)
	save_menu.visible = true

func _on_cancel_pressed():
	main_menu.visible = true
	save_menu.visible = false

func _on_settings_pressed():
	main_menu.visible = false
	settings_menu.visible = true

func _on_back_pressed():
	main_menu.visible = true
	settings_menu.visible = false

func _on_quit_pressed():
	get_tree().quit()
