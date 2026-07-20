extends Node2D

@onready var player = get_parent() as CharacterBody2D

@onready var flashlight_beam: PointLight2D = $PointLight2D

@onready var battery_manager = $BatteryManager
@onready var effects_manager = $EffectsManager
@onready var audio_manager = $AudioManager

const ROTATE_SPEED := 12.0
const MAX_ANGLE := deg_to_rad(60.0)

const DEBUG_FLASHLIGHT := false

var debug_timer := 0.0

# Prevents multiple toggle requests while waiting
var is_toggling := false

func _process(delta):

	# Debug Output
	if DEBUG_FLASHLIGHT:
		debug_timer += delta
		if debug_timer >= 1.0:
			debug_timer = 0.0
			print_debug_info()
			
	# Toggle Flashlight
	if Input.is_action_just_pressed("flashlightOn-Off"):
		if !is_toggling:
			try_toggle_flashlight()

	# Battery + Effects
	if flashlight_beam.enabled:
		battery_manager.update_battery(delta)
		effects_manager.update_effects(delta)
		if battery_manager.is_dead():
			flashlight_beam.enabled = false

	# Player Check
	if player == null:
		return

	var mouse_angle = (get_global_mouse_position() - global_position).angle()

	if player.velocity.length() > 0.1:

		var facing_angle := 0.0

		match player.last_direction:
			0:
				facing_angle = PI / 2

			1:
				facing_angle = -PI / 2

			2:
				if player.sprite.flip_h:
					facing_angle = PI
				else:
					facing_angle = 0

		var diff = wrapf(mouse_angle - facing_angle, -PI, PI)

		diff = clamp(diff, -MAX_ANGLE, MAX_ANGLE)
		mouse_angle = facing_angle + diff
	rotation = lerp_angle(rotation, mouse_angle, ROTATE_SPEED * delta)


func try_toggle_flashlight():

	if !battery_manager.can_turn_on():
		return
		
	is_toggling = true

	var percent = battery_manager.battery_percent()
	var chance := 0.0
	var min_delay := 0.0
	var max_delay := 0.0

	# -----------------------------
	# Delay Levels
	# -----------------------------
	if percent <= 0.05:
		chance = 0.90
		min_delay = 0.30
		max_delay = 0.60

	elif percent <= 0.10:
		chance = 0.70
		min_delay = 0.25
		max_delay = 0.45

	elif percent <= 0.20:
		chance = 0.45
		min_delay = 0.15
		max_delay = 0.30

	elif percent <= 0.30:
		chance = 0.25
		min_delay = 0.10
		max_delay = 0.20

	elif percent <= 0.40:
		chance = 0.10
		min_delay = 0.05
		max_delay = 0.10

	# Play switch click immediately
	audio_manager.play_toggle()

	# Simulate weak battery delay
	if randf() < chance:
		await get_tree().create_timer(
			randf_range(min_delay, max_delay)
		).timeout
	flashlight_beam.enabled = !flashlight_beam.enabled

	# Play click again when light actually changes state
	audio_manager.play_toggle()
	is_toggling = false

####################################################
# CUTSCENE FUNCTIONS
####################################################
func turn_on() -> void:
	flashlight_beam.enabled = true

func turn_off() -> void:
	flashlight_beam.enabled = false

func set_enabled(enabled: bool) -> void:
	flashlight_beam.enabled = enabled

func print_debug_info():

	print("\n================ FLASHLIGHT DEBUG ================")
	print("Battery        : %.1f / %.1f" % [
		battery_manager.battery,
		battery_manager.max_battery
	])
	print("Battery %%      : %.1f%%" % (
		battery_manager.battery_percent() * 100.0
	))
	print("Flashlight ON  : ", flashlight_beam.enabled)
	print("Light Energy   : %.2f" % flashlight_beam.energy)
	print("Drain Speed    : %.2f" % battery_manager.drain_speed)
	print("Breath Speed   : %.2f" % effects_manager.breathe_speed)
	print("Breath Amount  : %.2f" % effects_manager.breathe_strength)
	print("Flicker Intvl  : %.2f" % effects_manager.flicker_interval)
	print("Flicker Amount : %.2f" % effects_manager.flicker_strength)
	print("==================================================")
