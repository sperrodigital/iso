extends Node

# How often (in seconds) weather can change
@export var min_interval := 300.0
@export var max_interval := 600.0

# Weights for how likely each weather type is (must match Weather enum order)
# CLEAR, RAIN, STORM, SNOW
@export var weather_weights := [50, 50]

var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	_schedule_next_change()

func _schedule_next_change() -> void:
	var wait_time = randf_range(min_interval, max_interval)
	_timer.start(wait_time)

func _on_timer_timeout() -> void:
	var new_weather = _pick_random_weather()
	
	# Avoid picking the same weather twice in a row
	while new_weather == WeatherManager.current_weather:
		new_weather = _pick_random_weather()
	
	WeatherManager.set_weather(new_weather)
	_schedule_next_change()

func _pick_random_weather() -> WeatherManager.Weather:
	var total = weather_weights.reduce(func(a, b): return a + b)
	var roll = randi() % total
	var cumulative = 0
	for i in weather_weights.size():
		cumulative += weather_weights[i]
		if roll < cumulative:
			return i as WeatherManager.Weather
	return WeatherManager.Weather.CLEAR
