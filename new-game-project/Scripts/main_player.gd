extends CharacterBody2D

const WALK_SPEED = 50.0
const SPRINT_SPEED = 120.0

const MAX_STAMINA = 100.0
const STAMINA_DRAIN = 25.0
const STAMINA_RECOVERY = 15.0

const AUTO_WALK_SPEED := 50.0
const AUTO_WALK_STOP_DISTANCE := 12.0

var controls_enabled := true
var auto_walk := false
var auto_walk_target := Vector2.ZERO

var stamina = MAX_STAMINA

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# 0 = Down, 1 = Up, 2 = Side
var last_direction = 0


func _physics_process(delta: float) -> void:

	####################################################
	# AUTO WALK (CUTSCENE)
	####################################################

	if auto_walk:
		var direction = auto_walk_target - global_position

		if direction.length() <= AUTO_WALK_STOP_DISTANCE:

			stop_auto_walk()

		else:

			direction = direction.normalized()

			velocity = direction * AUTO_WALK_SPEED

			sprite.speed_scale = 0.67

			if abs(direction.x) > abs(direction.y):

				last_direction = 2
				sprite.flip_h = direction.x < 0
				sprite.play("Walk_Side")

			else:

				if direction.y < 0:
					last_direction = 1
					sprite.flip_h = false
					sprite.play("Walk_Up")
				else:
					last_direction = 0
					sprite.flip_h = false
					sprite.play("Walk_Down")

		move_and_slide()
		return


	####################################################
	# PLAYER DISABLED
	####################################################

	if !controls_enabled:

		velocity = Vector2.ZERO
		sprite.speed_scale = 1.0

		match last_direction:
			0:
				sprite.play("Idle_Down")
			1:
				sprite.play("Idle_Up")
			2:
				sprite.play("Idle_Side")

		move_and_slide()
		return


	####################################################
	# HANDLE ENTER
	####################################################

	if Input.is_action_just_pressed("enter"):
		print("took things into inventory...")


	####################################################
	# INPUT
	####################################################

	var direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	if direction != Vector2.ZERO:
		direction = direction.normalized()


	####################################################
	# STAMINA
	####################################################

	var sprinting := false

	if Input.is_action_pressed("sprint") and direction != Vector2.ZERO and stamina > 0.0:

		sprinting = true

		stamina -= STAMINA_DRAIN * delta

		if stamina <= 0.0:

			stamina = 0.0
			sprinting = false

	else:

		stamina += STAMINA_RECOVERY * delta
		stamina = min(stamina, MAX_STAMINA)

	var current_speed = WALK_SPEED

	if sprinting:
		current_speed = SPRINT_SPEED


	####################################################
	# NORMAL MOVEMENT
	####################################################

	if direction != Vector2.ZERO:
		velocity = direction * current_speed
		if sprinting:
			sprite.speed_scale = 1.0
		else:
			sprite.speed_scale = 0.67

		if abs(direction.x) > abs(direction.y):

			last_direction = 2
			sprite.flip_h = direction.x < 0
			sprite.play("Walk_Side")

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
		sprite.speed_scale = 1.0
		match last_direction:
			0:
				sprite.play("Idle_Down")
			1:
				sprite.play("Idle_Up")
			2:
				sprite.play("Idle_Side")

	move_and_slide()


func _input(event):

	if !controls_enabled or auto_walk:
		return
	if velocity != Vector2.ZERO:
		return
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
				
####################################################
# PLAYER CONTROL FUNCTIONS
####################################################

func set_controls_enabled(enabled: bool) -> void:
	print("Controls Enabled =", enabled)
	controls_enabled = enabled

####################################################
# AUTO WALK FUNCTIONS
####################################################

func start_auto_walk(target: Vector2) -> void:
	auto_walk = true
	auto_walk_target = target

func stop_auto_walk() -> void:
	auto_walk = false
	velocity = Vector2.ZERO
	sprite.speed_scale = 1.0

	match last_direction:
		0:
			sprite.play("Idle_Down")
		1:
			sprite.play("Idle_Up")
		2:
			sprite.play("Idle_Side")
