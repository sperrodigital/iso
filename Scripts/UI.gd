extends Control

@onready var wood_label: Label = $Panel/VBoxContainer/WoodLabel
@onready var stone_label: Label = $Panel/VBoxContainer/StoneLabel

func _ready() -> void:
	Inventory.inventory_changed.connect(_on_inventory_changed)

func _on_inventory_changed() -> void:
	wood_label.text = "Wood: %d" % Inventory.get_item("Wood")
	stone_label.text = "Stone: %d" % Inventory.get_item("Stone")
