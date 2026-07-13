extends CharacterBody2D

const SPEED = 120.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# 0 = Down, 1 = Up, 2 = Side
var last_direction = 0


func _physics_process(delta: float) -> void:

	# Handle enter
	if Input.is_action_just_pressed("enter"):
		print("took things into inventory...")

	var direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	# ==========================
	# MOVEMENT (Highest Priority)
	# ==========================
	if direction != Vector2.ZERO:

		direction = direction.normalized()
		velocity = direction * SPEED

		# Horizontal movement
		if abs(direction.x) > abs(direction.y):

			last_direction = 2
			sprite.flip_h = direction.x < 0
			sprite.play("Walk_Side")

		# Vertical movement
		else:

			if direction.y < 0:
				last_direction = 1
				sprite.flip_h = false
				sprite.play("Walk_Up")
			else:
				last_direction = 0
				sprite.flip_h = false
				sprite.play("Walk_Down")

	else:

		velocity = Vector2.ZERO

		match last_direction:
			0:
				sprite.play("Idle_Down")
			1:
				sprite.play("Idle_Up")
			2:
				sprite.play("Idle_Side")

	move_and_slide()


func _input(event):

	# Don't change facing while moving
	if velocity != Vector2.ZERO:
		return

	# Only rotate when the mouse actually moves
	if event is InputEventMouseMotion:

		var mouse_dir = get_global_mouse_position() - global_position

		if abs(mouse_dir.x) > abs(mouse_dir.y):

			last_direction = 2
			sprite.flip_h = mouse_dir.x < 0

		else:

			if mouse_dir.y < 0:
				last_direction = 1
				sprite.flip_h = false
			else:
				last_direction = 0
				sprite.flip_h = false
