extends Node2D

@export var item_name := "cloth"
@export var item_amount := 2
@export var hits_required := 5
@export var respawn_time := 30
@export var item_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var hit_sfx: AudioStreamPlayer = $HitSFX
@onready var harvested_sfx: AudioStreamPlayer = $HarvestedSFX

signal harvested(item: String, amount: int)

var player_nearby := false
var mouse_hovering := false
var can_harvest := true
var hits_remaining: int

func _ready() -> void:
	# set item sprite texture
	sprite.material = sprite.material.duplicate()
	if item_texture:
		sprite.texture = item_texture
	
	# set required hits for node
	hits_remaining = hits_required
	
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
	
	area.input_pickable = true
	area.input_event.connect(_on_area_input)
	harvested.connect(_on_harvested)
	_set_outline(false)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		_update_outline()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		_update_outline()

func _on_area_input(viewpost: Viewport, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if not player_nearby:
			return
		harvest()
		
func harvest():
	if not can_harvest:
		return

	hits_remaining -= 1
	_shake_sprite()
			
	if hits_remaining <= 0:
		_complete_harvest()
	else:
		if hit_sfx.stream:
			hit_sfx.play()


func _complete_harvest():
	can_harvest = false
	sprite.modulate.a = 0.3
	_set_outline(false)
	emit_signal("harvested", item_name, item_amount)
	harvested_sfx.play()
	sprite.visible = false
	print("Cloth harvested")
	get_tree().create_timer(respawn_time).timeout.connect(_respawn)

func _respawn():
	print("Respawning cloth")
	can_harvest = true
	sprite.visible = true
	hits_remaining = hits_required
	sprite.modulate.a = 1.0
	if player_nearby:
		_set_outline(true)

func _on_harvested(item: String, amount: int):
	for i in amount:
		Inventory.add_item({ "name": item})

func _on_mouse_entered() -> void:
	mouse_hovering = true
	_update_outline()

func _on_mouse_exited() -> void:
	mouse_hovering = false
	_update_outline()

func _update_outline() -> void:
	_set_outline(player_nearby or mouse_hovering)

func _set_outline(enabled: bool):
	sprite.material.set_shader_parameter("outline_enabled", enabled)
	
func _shake_sprite():
	var tween = create_tween()
	var origin = sprite.position
	tween.tween_property(sprite, "position", origin + Vector2(2, 0), 0.05)
	tween.tween_property(sprite, "position", origin + Vector2(-2, 0), 0.05)
	tween.tween_property(sprite, "position", origin + Vector2(1, 0), 0.05)
	tween.tween_property(sprite, "position", origin, 0.05)
