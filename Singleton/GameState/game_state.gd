extends Node

enum State { MAIN_MENU, PLAYING, PAUSED }

# Player state
var is_interacting := false
var current_state: State = State.MAIN_MENU

func is_playing() -> bool:
	return current_state == State.PLAYING
	
func is_main_menu() -> bool:
	return current_state == State.MAIN_MENU

func is_paused() -> bool:
	return current_state == State.PAUSED
	
func set_state(new_state: State):
	current_state = new_state
