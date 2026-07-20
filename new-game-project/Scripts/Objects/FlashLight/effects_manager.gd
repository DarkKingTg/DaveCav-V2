extends Node

@onready var flashlight: PointLight2D = $"../PointLight2D"
@onready var battery = $"../BatteryManager"

# -------------------------------------------------------
# Timers
# -------------------------------------------------------

var breathe_timer := 0.0
var flicker_timer := 0.0
var power_drop_timer := 0.0

# -------------------------------------------------------
# Debug Variables
# -------------------------------------------------------

var breathe_speed := 1.5
var breathe_strength := 0.02

var flicker_interval := 1.2
var flicker_strength := 0.03

var base_energy := 1.3
var current_energy := 1.3

# -------------------------------------------------------

func update_effects(delta):

	var p = battery.battery_percent()

	# ---------------------------------------------------
	# Base Light Energy
	# ---------------------------------------------------
	base_energy = lerp(0.20, 1.30, p)
	current_energy = base_energy

	# ---------------------------------------------------
	# Breathing
	# ---------------------------------------------------
	breathe_speed = lerp(8.0, 1.5, p)
	breathe_strength = lerp(0.35, 0.02, p)
	breathe_timer += delta
	current_energy += sin(breathe_timer * breathe_speed) * breathe_strength

	# ---------------------------------------------------
	# Flickering
	# ---------------------------------------------------
	flicker_interval = lerp(0.03, 1.20, p)
	flicker_strength = lerp(0.90, 0.02, p)
	flicker_timer += delta
	if flicker_timer >= flicker_interval:
		flicker_timer = 0.0
		current_energy -= randf() * flicker_strength

	# ---------------------------------------------------
	# Random Power Drops
	# Battery below 40%
	# ---------------------------------------------------
	if p < 0.40:
		power_drop_timer -= delta
		if power_drop_timer <= 0:
			power_drop_timer = randf_range(2.0, 5.0)
			current_energy *= randf_range(0.45, 0.80)

	# ---------------------------------------------------
	# Critical Battery (<10%)
	# ---------------------------------------------------
	if p < 0.10:
		if randf() < 0.15:
			current_energy *= randf_range(0.10, 0.50)

	# ---------------------------------------------------
	# Clamp
	# ---------------------------------------------------
	current_energy = max(current_energy, 0.0)
	flashlight.energy = current_energy
