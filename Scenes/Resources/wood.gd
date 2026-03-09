# ground_item.gd
extends Area2D

@export var item_data: Dictionary = {
	"name": "Wood",
	"type": "resource",
	"value": 1
}

@onready var pickup_sound = $AudioStreamPlayer2D

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		if Inventory.add_item(item_data):
			_play_pickup_sound()

func _play_pickup_sound():
	var sound = pickup_sound
	remove_child(sound)
	get_tree().root.add_child(sound)
	sound.pitch_scale = randf_range(0.8, 1.2)  # Add this line
	sound.play()
	sound.finished.connect(sound.queue_free)
	queue_free()
