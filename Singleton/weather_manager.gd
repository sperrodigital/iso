extends Node

enum Weather { CLEAR, RAIN }

var current_weather: Weather = Weather.CLEAR

@onready var rain_particles: GPUParticles2D = $RainDrops
@onready var rain_audio: AudioStreamPlayer = $AudioStreamPlayer

@export var rain_stream: AudioStream

const AUDIO_FADE_DURATION := 2.0
const MIN_DB := -80.0

const PRESETS = {
	Weather.CLEAR: { "rain": 0   },
	Weather.RAIN:  { "rain": 800 },
}

signal weather_changed(new_weather: Weather)

func _ready() -> void:
	rain_particles.emitting = false

func set_weather(new_weather: Weather) -> void:
	if new_weather == current_weather:
		return
	current_weather = new_weather
	_apply_preset(PRESETS[new_weather])
	emit_signal("weather_changed", new_weather)

func _apply_preset(preset: Dictionary):
	if preset["rain"] > 0:
		rain_particles.amount = preset["rain"]
		rain_particles.emitting = true
	else:
		rain_particles.emitting = false

	match current_weather:
		Weather.RAIN:
			rain_audio.stream = rain_stream
			_fade_in(rain_audio)
		Weather.CLEAR:
			_fade_out(rain_audio)

func _fade_in(player: AudioStreamPlayer):
	if player.stream == null:
		return
	player.volume_db = MIN_DB
	player.play()
	var tween = create_tween()
	tween.tween_property(player, "volume_db", 0.0, AUDIO_FADE_DURATION)

func _fade_out(player: AudioStreamPlayer):
	if not player.playing:
		return
	var tween = create_tween()
	tween.tween_property(player, "volume_db", MIN_DB, AUDIO_FADE_DURATION)
	tween.tween_callback(player.stop)
