extends Area2D

@export var cutscene_manager: Node
@export var animation_name := "Intro"

var played := false


func _on_body_entered(body):
	if played:
		return

	if body.name != "MainPlayer":
		return

	played = true

	cutscene_manager.play_cutscene(animation_name)
