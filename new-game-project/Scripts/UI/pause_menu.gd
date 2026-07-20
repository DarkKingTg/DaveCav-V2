extends Control

@onready var resume: TextureButton = $Panel/Margin/Buttons/Resume
@onready var settings: TextureButton = $Panel/Margin/Buttons/Settings
@onready var save_exit: TextureButton = $Panel/Margin/Buttons/SaveExit

@onready var settings_menu: Control = $"../Settings"


func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):

		# Close Settings if it's open
		if settings_menu.visible:
			settings_menu.hide()
			show()

		# Resume game if Pause Menu is open
		elif visible:
			resume_game()

		# Otherwise pause the game
		else:
			pause_game()


func pause_game() -> void:
	if get_tree().paused:
		return

	get_tree().paused = true
	show()


func resume_game() -> void:
	hide()
	settings_menu.hide()
	get_tree().paused = false


func open_settings() -> void:
	hide()
	settings_menu.show()


func close_settings() -> void:
	settings_menu.hide()
	show()


func _on_resume_pressed() -> void:
	resume_game()


func _on_settings_pressed() -> void:
	open_settings()


func _on_save_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
