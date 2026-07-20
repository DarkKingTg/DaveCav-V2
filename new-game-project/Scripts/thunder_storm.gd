extends Node2D

@onready var flash = $Lightning/Flash
@onready var thunder1 = $ThunderSoundEffect1
@onready var thunder2 = $ThunderSoundEffect2
@onready var rain = $RainSoundEffect
@onready var camera = $"../Camera2D"


var flickers = randi_range(2, 5)

func _ready():
	randomize()
	rain.play()
	start_storm()

func start_storm():
	while true:
		await get_tree().create_timer(randf_range(5.0,12.0)).timeout
		await lightning_sequence()
		
func flicker_window_lights():
	var entrance = get_tree().current_scene.get_node("Main Enterance")
	var lights_parent = entrance.get_node("window_lights")

	for light in lights_parent.get_children():
		if light is PointLight2D:
			flicker_single_light(light)
		
func flicker_single_light(light):
	if !is_instance_valid(light):
		return
	var original_energy = light.energy
	await get_tree().create_timer(randf_range(0.0, 0.4)).timeout
	light.energy = 0.0
	
	for i in range(flickers):
		await get_tree().create_timer(randf_range(0.03, 0.08)).timeout
		light.energy = original_energy
		
		await get_tree().create_timer(randf_range(0.03, 0.08)).timeout
		light.energy = 0.0
	await get_tree().create_timer(randf_range(0.2, 2.0)).timeout
	light.energy = original_energy
func lightning_sequence():
	# First flash
	flash.color.a = 0.8
	await get_tree().create_timer(0.05).timeout

	flash.color.a = 0.0
	await get_tree().create_timer(0.08).timeout

	# Second flash
	flash.color.a = 1.0
	await get_tree().create_timer(0.06).timeout
	
	flash.color.a = 0.0
	# Thunder delay
	await get_tree().create_timer(randf_range(0.4,1.2)).timeout

	if randi() % 2 == 0:
		thunder1.play()
		print("Thunder1")
		camera.shake(9)
		flicker_window_lights()
	else:
		thunder2.play()
		print("Thunder2")
		camera.shake(11)
		flicker_window_lights()
