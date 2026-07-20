extends Node2D

@onready var light: PointLight2D = $PointLight2D

# ----------------------------
# Breathing
# ----------------------------
@export_group("Breathing")

@export var breathing_enabled := true
@export var breathing_speed := 1.2
@export var breathing_energy_strength := 0.08
@export var breathing_scale_strength := 0.03

# ----------------------------
# Flicker
# ----------------------------
@export_group("Flicker")

@export var flicker_enabled := true

@export var min_energy := 0.45
@export var max_energy := 1.0

@export var min_texture_scale := 0.90
@export var max_texture_scale := 1.08

@export var min_delay := 0.5
@export var max_delay := 4.0

@export var min_flickers := 2
@export var max_flickers := 6

@export var flicker_speed := 0.05

# ----------------------------

var base_energy := 1.0
var base_scale := 1.0

var flickering := false


func _ready() -> void:
	randomize()

	base_energy = light.energy
	base_scale = light.texture_scale

	if flicker_enabled:
		_flicker_loop()


func _process(delta: float) -> void:

	if breathing_enabled and !flickering:

		var t := Time.get_ticks_msec() / 1000.0

		light.energy = base_energy + sin(t * breathing_speed) * breathing_energy_strength

		light.texture_scale = base_scale + sin(t * breathing_speed) * breathing_scale_strength


func _flicker_loop() -> void:

	while true:

		await get_tree().create_timer(
			randf_range(min_delay, max_delay)
		).timeout

		flickering = true

		var amount := randi_range(min_flickers, max_flickers)

		for i in range(amount):

			light.energy = randf_range(min_energy, max_energy)
			light.texture_scale = randf_range(min_texture_scale, max_texture_scale)

			await get_tree().create_timer(flicker_speed).timeout

		flickering = false

		light.energy = base_energy
		light.texture_scale = base_scale
