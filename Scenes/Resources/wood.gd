# ground_item.gd
extends Area2D

@export var item_name: String = "Wood"
@export var item_type: String = "resource"
@export var item_value: int = 1
@export var item_icon: Texture2D = null


@onready var pickup_sound = $AudioStreamPlayer2D

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		print("player getting wood...")
		if Inventory.add_item({
			"name": item_name,
			"type": item_type,
			"value": item_value,
			"icon": item_icon
		}):
			print("picked up...")
			_play_pickup_sound()

func _play_pickup_sound():
	var sound = pickup_sound
	remove_child(sound)
	get_tree().root.add_child(sound)
	sound.pitch_scale = randf_range(0.8, 1.2)  # Add this line
	sound.play()
	sound.finished.connect(sound.queue_free)
	queue_free()
