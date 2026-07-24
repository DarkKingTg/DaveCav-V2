extends Node
class_name IntroManager

@export_group("References")
@export var cutscene_manager: CutSceneManager

@export var gate_marker: Marker2D
@export var gate_arrival: Area2D

@export var intro_ui: IntroUI

@export var flashlight: Node
@export var thunder_storm: Node

@export_group("Optional UI")
@onready var objective_ui: ObjectiveUI = get_tree().current_scene.get_node("UI/ObjectiveUI")
@export var control_hint_ui: Node


func play_intro() -> void:

	####################################################
	# BEGIN CUTSCENE
	####################################################

	cutscene_manager.begin_cutscene("Intro")


	####################################################
	# FLASHLIGHT OFF
	####################################################

	if flashlight != null:

		if flashlight.has_method("turn_off"):
			flashlight.turn_off()

		elif flashlight.has_method("set_enabled"):
			flashlight.set_enabled(false)


	####################################################
	# START WEATHER
	####################################################

	if thunder_storm != null:

		if thunder_storm.has_method("start"):
			thunder_storm.start()


	####################################################
	# FADE IN
	####################################################

	if intro_ui != null:
		await intro_ui.fade_in()


	####################################################
	# START STORY
	####################################################

	intro_ui.play_intro()


	####################################################
	# WAIT FOR WORLD REVEAL
	####################################################

	await intro_ui.reveal_world


	####################################################
	# START WORLD REVEAL
	####################################################

	var fade_tween := intro_ui.fade_out()
	var move_tween := intro_ui.move_story_to_bottom()

	if gate_marker == null:

		push_error("IntroManager: Gate Marker missing.")

		cutscene_manager.end_cutscene()

		return


	####################################################
	# PLAYER STARTS WALKING
	####################################################

	cutscene_manager.start_walk(
		gate_marker.global_position,
		gate_arrival
	)


	####################################################
	# WAIT FOR STORY
	####################################################
	await intro_ui.intro_finished

	####################################################
	# WAIT FOR PLAYER
	####################################################
	await cutscene_manager.walk_finished

	####################################################
	# WAIT FOR ANIMATIONS
	####################################################

	await get_tree().create_timer(
	max(intro_ui.fade_duration, intro_ui.story_move_duration)
).timeout

	####################################################
	# HIDE INTRO UI
	####################################################

	intro_ui.hide()


	####################################################
	# END CUTSCENE
	####################################################
	cutscene_manager.end_cutscene()
	objective_ui.show_objectives()

	####################################################
	# OBJECTIVE
	####################################################

	if objective_ui != null:

		if objective_ui.has_method("show_objective"):
			objective_ui.show_objective(
				"Enter the mansion through the gate."
			)


	####################################################
	# CONTROL HINT
	####################################################

	if control_hint_ui != null:

		if control_hint_ui.has_method("show_hint_movement_only"):
			control_hint_ui.show_hint_movement_only()
