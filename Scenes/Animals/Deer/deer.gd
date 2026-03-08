extends CharacterBody2D

const SPEED := 50.0
const IDLE_TIME_MIN := 2.0
const IDLE_TIME_MAX := 5.0
const WANDER_TIME_MIN := 1.0
const WANDER_TIME_MAX := 3.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum State { IDLE, WANDER }
var state := State.IDLE
var wander_direction := Vector2.ZERO
var timer := 0.0

func _ready() -> void:
	_enter_idle()

func _physics_process(delta: float) -> void:
	timer -= delta

	match state:
		State.IDLE:
			if timer <= 0.0:
				_enter_wander()
		State.WANDER:
			velocity = wander_direction * SPEED
			move_and_slide()
			if timer <= 0.0:
				_enter_idle()

func _enter_idle() -> void:
	state = State.IDLE
	velocity = Vector2.ZERO
	timer = randf_range(IDLE_TIME_MIN, IDLE_TIME_MAX)
	sprite.play("idle")

func _enter_wander() -> void:
	state = State.WANDER
	timer = randf_range(WANDER_TIME_MIN, WANDER_TIME_MAX)
	wander_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	sprite.flip_h = wander_direction.x < 0
	sprite.play("walk")
