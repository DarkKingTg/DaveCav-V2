extends Node

signal cutscene_state_changed(active: bool)

var is_cutscene_active: bool = false:
	set(value):
		if is_cutscene_active == value:
			return

		is_cutscene_active = value
		cutscene_state_changed.emit(is_cutscene_active)


func set_cutscene_active(active: bool) -> void:
	is_cutscene_active = active


func begin_cutscene() -> void:
	set_cutscene_active(true)


func end_cutscene() -> void:
	set_cutscene_active(false)


func is_cutscene() -> bool:
	return is_cutscene_active
