extends Area2D

@export var item_name: String = "Item"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		#Inventory.add_item(item_name)
		queue_free()
