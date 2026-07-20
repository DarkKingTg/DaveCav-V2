extends Node

@export var max_battery := 150.0
@export var battery := 150.0
@export var drain_speed := 0.65

func update_battery(delta):
	battery -= drain_speed * delta
	battery = clamp(battery,0.0,max_battery)

func battery_percent():
	return battery / max_battery

func replace_battery():
	battery = max_battery
	
func can_turn_on():
	return battery > 0
	
func is_dead():
	return battery <= 0
