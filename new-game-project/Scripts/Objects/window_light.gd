extends PointLight2D

@export var min_off_time := 0.2
@export var max_off_time := 2.0

var _busy := false

func thunder_flicker():
	if _busy:
		return
	_busy = true
	var original_energy = energy
	
	# Turn off immediately
	energy = 0.0
	
	# Random flickers
	var flickers = randi_range(2, 6)
	for i in range(flickers):
		await get_tree().create_timer(randf_range(0.03, 0.12)).timeout
		energy = original_energy
		await get_tree().create_timer(randf_range(0.03, 0.08)).timeout
		energy = 0.0
		
	# Stay off for a random duration
	await get_tree().create_timer(
		randf_range(min_off_time, max_off_time)
	).timeout

	# Restore light
	energy = original_energy
	_busy = false
