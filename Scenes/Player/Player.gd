extends CharacterBody2D

const SPEED := 60.0

# Maps 45° movement sector (0=E, 1=SE, 2=S, 3=SW, 4=W, 5=NW, 6=N, 7=NE) → animation name
const SECTOR_TO_ANIM := [
	"walk_right",      # E
	"walk_right_down", # SE
	"walk_down",       # S
	"walk_left_down",  # SW
	"walk_left",       # W
	"walk_up_left",    # NW
	"walk_up",         # N
	"walk_up_right",   # NE
]

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _physics_process(_delta: float) -> void:
	var input := Vector2(
		Input.get_axis("walk_left", "walk_right"),
		Input.get_axis("walk_up", "walk_down")
	)

	if input != Vector2.ZERO:
		var iso_input := Vector2(input.x * 2.0, input.y)
		velocity = iso_input.normalized() * SPEED

		# Keep angle from raw input so controls still feel correct
		var angle := input.angle()
		var sector := int(round(angle / (PI / 4.0))) % 8
		if sector < 0:
			sector += 8
		sprite.play(SECTOR_TO_ANIM[sector])

	else:
		velocity = Vector2.ZERO
		sprite.play("default")

	move_and_slide()
