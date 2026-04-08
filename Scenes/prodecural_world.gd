extends Node2D

# Determine how large we want the map

const MAP_WIDTH= 40
const MAP_HEIGHT= 40

# Tilemap sources
const TILE_SOURCE_ID = 1
const TILE_LAND = Vector2i(4,6)
const TILE_WATER = Vector2i(6,6)


# TilemapLayer node
@onready var tile_map: TileMapLayer = $MapLayer

# noise values
var noise_map = []

# Noise generator
var noise = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("tile map is: ", tile_map)
	setup_noise()
	generate_noise_map()
	generate_tiles()

func generate_tiles():
	#print("Generating tiles")
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			var value = noise_map[x][y]
			var tile_coords = get_tile_for_value(value)
			#print("Setting cell " , x, ", ", y, " to ", tile_coords)
			tile_map.set_cell(Vector2i(x,y), TILE_SOURCE_ID, tile_coords)
			
func get_tile_for_value(value: float):
	if value < 0.0:
		return TILE_WATER
	else:
		return TILE_LAND

func setup_noise():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = 3			# fixed seed so map is the same each run for now
	noise.frequency = 0.02 	# Lower = larger landmasses, higher = choppier terrain

func generate_noise_map():
	noise_map= [] # start with clear map
	
	for x in range(MAP_WIDTH):
		var column = []
		for y in range(MAP_HEIGHT):
			var value = noise.get_noise_2d(x, y)
			column.append(value)
		noise_map.append(column)

	# Debug test to see map seed in ascii outpu
	#for y in range(MAP_HEIGHT):
		#var row = ""
		#for x in range(MAP_WIDTH):
			#var v = noise_map[x][y]
			#if v < 0.0:
				#row += "~ "   # water
			#else:
				#row += ". "   # land
		#print(row)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
