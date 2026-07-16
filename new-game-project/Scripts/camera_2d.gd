extends Camera2D

var shake_strength := 0.0
var shake_fade := 20.0
var shake_interval := 0.05 # Change every 0.05 sec (20 times/sec)
var shake_timer := 0.0

func _process(delta):
	if shake_strength > 0:
		shake_timer -= delta

		if shake_timer <= 0:
			shake_timer = shake_interval
			offset = Vector2(
				randf_range(-shake_strength, shake_strength),
				randf_range(-shake_strength, shake_strength)
			)

		shake_strength = move_toward(shake_strength, 0.0, shake_fade * delta)
	else:
		offset = Vector2.ZERO


func shake(amount: float):
	shake_strength = amount
