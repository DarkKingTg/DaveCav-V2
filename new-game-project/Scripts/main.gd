extends Node2D

@onready var pause_menu = $UI/PauseMenu

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back") and !event.is_echo():

		if pause_menu.visible:
			pause_menu.resume_game()
		else:
			pause_menu.pause_game()
