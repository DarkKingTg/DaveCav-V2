extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu
@onready var settings: Control = $Settings
@onready var hud: Control = $HUD
@onready var game_over: Control = $GameOver
@onready var transition: Control = $Transition


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	pause_menu.hide()
	settings.hide()
	game_over.hide()
	transition.hide()
	hud.show()


func show_game_over() -> void:
	get_tree().paused = true
	game_over.show()


func hide_game_over() -> void:
	game_over.hide()
	get_tree().paused = false


func show_hud() -> void:
	hud.show()


func hide_hud() -> void:
	hud.hide()


func show_transition() -> void:
	transition.show()


func hide_transition() -> void:
	transition.hide()


func fade_in() -> void:
	# Add AnimationPlayer code here later
	pass


func fade_out() -> void:
	# Add AnimationPlayer code here later
	pass
