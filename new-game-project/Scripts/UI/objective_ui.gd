extends CanvasLayer
class_name ObjectiveUI

####################################################
# NODES
####################################################

@onready var collapse_button: TextureButton = $MarginContainer/Panel/CollapseButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

####################################################
# VARIABLES
####################################################

var collapsed: bool = false

####################################################
# READY
####################################################

func _ready():
	collapse_button.pressed.connect(func():
		print("DIRECT SIGNAL")
	)
####################################################
# COLLAPSE BUTTON
####################################################

func _on_collapse_button_pressed() -> void:
	print("BUTTON PRESSED")
	if animation_player.is_playing():
		return

	if collapsed:
		animation_player.play("expand")
	else:
		animation_player.play("collapse")

####################################################
# ANIMATION CALLBACK
####################################################

func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Colapse":
			collapsed = true
			collapse_button.scale.x = -1

		"Expand":
			collapsed = false
			collapse_button.scale.x = 1

func show_objectives() -> void:
	visible = true
	animation_player.play("Show")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Mouse clicked")
