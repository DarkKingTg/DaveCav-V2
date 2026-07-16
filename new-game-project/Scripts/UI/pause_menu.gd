extends Control

@onready var resume_button: TextureButton = $Panel/Buttons/Resume
@onready var settings_button: TextureButton = $Panel/Buttons/Settings
@onready var save_exit_button: TextureButton = $Panel/Buttons/SaveExit


func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		if visible:
			_on_resume_pressed()
		else:
			visible = true
			get_tree().paused = true

func _on_resume_pressed() -> void:
	get_parent().get_parent().resume_game()

func _on_settings_pressed() -> void:
	print("Settings")

func _on_save_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
