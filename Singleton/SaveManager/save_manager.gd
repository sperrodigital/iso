extends Node2D

const SAVE_FOLDER := "user://saves/"
const SLOT_COUNT := 3

signal game_loaded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !DirAccess.dir_exists_absolute(SAVE_FOLDER):
		DirAccess.make_dir_absolute(SAVE_FOLDER)

func _save_player(player):
	return {
		"position": player.global_position,
		"scene": player.get_tree().current_scene.scene_file_path
	}

func _load_player(player, data):
	player.global_position = data.position

func save_game(slot: int, player):
	var save_data:= {}
	save_data.player = _save_player(player)
	save_data.timestamp = Time.get_datetime_string_from_system()
	
	var file = FileAccess.open(get_slot_path(slot), FileAccess.WRITE)
	file.store_var(save_data)
	
	print("Game Saved: ", slot)

func load_game(slot: int, player):
	var path = get_slot_path(slot)
	
	if !FileAccess.file_exists(path):
		print("Save does not exist")
		return false
		
	var file = FileAccess.open(path, FileAccess.READ)
	var data = file.get_var()
	
	_load_player(player, data.player)
	
	print("Game Loaded: ", slot)
	game_loaded.emit()
	return true

func get_slot_path(slot: int) -> String:
	return SAVE_FOLDER + "slot_%d.save" % slot

func get_slot_time(slot: int):
	var path = get_slot_path(slot)
	
	if !FileAccess.file_exists(path):
		return null
	
	var file = FileAccess.open(path, FileAccess.READ)
	var data = file.get_var()
	
	return data.timestamp
