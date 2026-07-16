extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu

func _ready() -> void:
	pause_menu.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

func pause_game() -> void:
	get_tree().paused = true
	pause_menu.visible = true

func resume_game() -> void:
	get_tree().paused = false
	pause_menu.visible = false
