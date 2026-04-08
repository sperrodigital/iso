extends CharacterBody2D

# Movement settings
@export var walk_speed: float = 60.0
@export var min_walk_time: float = 1.0
@export var max_walk_time: float = 3.0
@export var min_idle_time: float = 1.0
@export var max_idle_time: float = 4.0
@export var min_eat_time: float = 1.5
@export var max_eat_time: float = 3.5
@export var eat_chance: float = 0.3  # 30% chance to eat instead of idle

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

enum State { IDLE, WALKING, EATING }
var state: State = State.IDLE
var direction: Vector2 = Vector2.ZERO
var timer: float = 0.0


func _ready() -> void:
	_enter_idle()


func _physics_process(delta: float) -> void:
	timer -= delta

	if timer <= 0.0:
		_pick_next_state()

	match state:
		State.WALKING:
			velocity = direction * walk_speed
			move_and_slide()
		State.IDLE, State.EATING:
			velocity = Vector2.ZERO


func _pick_next_state() -> void:
	match state:
		State.WALKING:
			# After walking, idle or eat
			if randf() < eat_chance:
				_enter_eating()
			else:
				_enter_idle()
		State.IDLE, State.EATING:
			# After idling/eating, walk in a new direction
			_enter_walking()


func _enter_idle() -> void:
	state = State.IDLE
	velocity = Vector2.ZERO
	timer = randf_range(min_idle_time, max_idle_time)
	_play_directional("idle")


func _enter_walking() -> void:
	state = State.WALKING
	timer = randf_range(min_walk_time, max_walk_time)
	# Pick a random angle and move in that direction
	var angle := randf() * TAU
	direction = Vector2(cos(angle), sin(angle))
	_play_directional("run")


func _enter_eating() -> void:
	state = State.EATING
	timer = randf_range(min_eat_time, max_eat_time)
	_play_directional("eating")


func _play_directional(base: String) -> void:
	# Use left/right variants based on horizontal direction
	# For idle/eating with no movement, keep the last facing direction
	if direction.x < 0:
		anim.play(base + "_left")
	else:
		anim.play(base + "_right")
