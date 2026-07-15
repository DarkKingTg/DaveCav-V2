extends Node2D

@onready var flash = $Lightning/Flash
@onready var thunder1 = $ThunderSoundEffect1
@onready var thunder2 = $ThunderSoundEffect2
@onready var rain = $RainSoundEffect
@onready var camera = $"../Camera2D"
func _ready():
	randomize()
	rain.play()
	start_storm()

func start_storm():
	while true:
		await get_tree().create_timer(randf_range(5.0,12.0)).timeout
		await lightning_sequence()

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
		camera.shake(8)
	else:
		thunder2.play()
		camera.shake(8)
