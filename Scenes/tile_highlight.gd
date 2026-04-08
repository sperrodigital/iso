extends Node2D

@onready var player: CharacterBody2D = $"../../Player"
@onready var ground: TileMapLayer = $".."
@export var interact_range: float = 32
@onready var timer: Timer = $Timer

const CROP_STAGES = [
	Vector2i(0,0), # Stage 0 - Just Planted
	Vector2i(2,2), # Stage 1 - Sprouting
	Vector2i(6,2), # Stage 2 - Growing
	Vector2i(2,3), # Ready to harvest
]

var hovered_tile := Vector2i.ZERO
var farm_data: Dictionary = {}

func _ready():
	timer.timeout.connect(_on_growth_tick)

func _on_growth_tick() -> void:
	for tile_pos in farm_data:
		var tile = farm_data[tile_pos]

		if typeof(tile) != TYPE_DICTIONARY:
			continue

		if tile.get("state", "") != "planted":
			continue

		var next_stage = tile.get("growth_stage", 0) + 1

		if next_stage >= CROP_STAGES.size():
			farm_data[tile_pos] = { "state": "ready" }
			print("crop ready at: ", tile_pos)
			continue

		# Replace the whole entry instead of mutating one key
		farm_data[tile_pos] = { "state": "planted", "crop": tile.get("crop", "wheat"), "growth_stage": next_stage }
		ground.set_cell(tile_pos, 0, CROP_STAGES[next_stage])
		print("grew to stage: ", next_stage)

func _process(_delta: float) -> void:
	if GameState.is_interacting:
		print("Player state: ", GameState.is_interacting)
		visible = false
		return
	
	var mouse_pos = get_global_mouse_position()
	var local_pos = ground.to_local(mouse_pos)
	hovered_tile = ground.local_to_map(local_pos)

	var tile_exists = ground.get_cell_source_id(hovered_tile) != -1
	visible = tile_exists
	queue_redraw()
	
func _draw() -> void:
	var tile_center = ground.to_global(ground.map_to_local(hovered_tile))
	var local_center = to_local(tile_center)
	var hw = 16.0
	var hh = 8.0
	var points = PackedVector2Array([
		local_center + Vector2(0, -hh),
		local_center + Vector2(hw, 0),
		local_center + Vector2(0, hh),
		local_center + Vector2(-hw, 0),
	])
	draw_polygon(points, [Color(1, 1, 1, 0.3)])
	draw_polyline(points + PackedVector2Array([points[0]]), Color(1, 1, 1, 0.8), 1.0)

func _input(event: InputEvent) -> void:
			
	# When left click is pressed
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if GameState.is_interacting:
			print("Checking player state on _input: ", GameState.is_interacting)
			return

	
		var tile_world_pos = ground.to_global(ground.map_to_local(hovered_tile))
		var distance = player.global_position.distance_to(tile_world_pos)
		
		# Check if player is close enough to till
		if distance > interact_range:
			return
					
		if farm_data.has(hovered_tile):
			var tile = farm_data[hovered_tile]
			if tile.get("state", "") == "ready":
				_harvest_crop(hovered_tile)
			return
			
		ground.set_cell(hovered_tile, 0, Vector2i(0,0))
		farm_data[hovered_tile] = { "state": "tilled" }

	# When right click is pressed
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed:
		if !farm_data.has(hovered_tile):
			print("not tilled")
			return
		if farm_data[hovered_tile]["state"] != "tilled":
			print("already planted")
			return
			
		ground.set_cell(hovered_tile, 0, Vector2i(4,2)) # stage atlas tile coord
		farm_data[hovered_tile] = { "state": "planted", "crop": "wheat", "growth_stage": 0 }

func _harvest_crop(tile_pos: Vector2i):
	var crop = farm_data[tile_pos].get("crop", "wheat")
	
	# add to inventory
	Inventory.add_item({ "name": "wheat", "type": "resource", "value": 1})
	
	# Reset tile to tilled
	ground.set_cell(tile_pos, 0, Vector2i(3,2))
	farm_data[tile_pos] = { "state": "tilled" }
	
	print("Harvested ", crop)
