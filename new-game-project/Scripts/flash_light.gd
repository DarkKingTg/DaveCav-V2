extends Node2D

@onready var player = get_parent() as CharacterBody2D
@onready var flashlight_beam: PointLight2D = $PointLight2D
@onready var FlashLightSound: AudioStreamPlayer2D = $AudioStreamPlayer2D
const ROTATE_SPEED := 12.0
const MAX_ANGLE := deg_to_rad(60.0)

func _process(delta):
	if Input.is_action_just_pressed("flashlightOn-Off"):
		flashlight_beam.enabled = !flashlight_beam.enabled
		FlashLightSound.play()
	if player == null:
		return

	var mouse_angle = (get_global_mouse_position() - global_position).angle()

	# Player moving?
	if player.velocity.length() > 0.1:

		var facing_angle := 0.0

		match player.last_direction:
			0: # Down
				facing_angle = PI / 2

			1: # Up
				facing_angle = -PI / 2

			2: # Side
				if player.sprite.flip_h:
					facing_angle = PI
				else:
					facing_angle = 0

		# Difference between mouse and facing
		var diff = wrapf(mouse_angle - facing_angle, -PI, PI)

		# Clamp to ±60°
		diff = clamp(diff, -MAX_ANGLE, MAX_ANGLE)

		mouse_angle = facing_angle + diff

	rotation = lerp_angle(rotation, mouse_angle, ROTATE_SPEED * delta)
