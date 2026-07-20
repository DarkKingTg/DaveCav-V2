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
@export var objective_ui: Node
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

	if intro_ui != null:
		intro_ui.play_intro()


	####################################################
	# WALK PLAYER
	####################################################

	if gate_marker == null:

		push_error("IntroManager : Gate Marker missing.")

		cutscene_manager.end_cutscene()

		return

	await cutscene_manager.walk_player_to(
		gate_marker.global_position,
		gate_arrival
	)


	####################################################
	# WAIT UNTIL STORY FINISHES
	####################################################

	if intro_ui != null:

		await intro_ui.intro_finished


	####################################################
	# FADE OUT
	####################################################

	if intro_ui != null:
		await intro_ui.fade_out()

	####################################################
	# END CUTSCENE
	####################################################

	cutscene_manager.end_cutscene()


	####################################################
	# OBJECTIVE
	####################################################

	if objective_ui != null:

		if objective_ui.has_method("show_objective"):

			objective_ui.show_objective(
				"Enter the mansion through the gate."
			)


	####################################################
	# CONTROLS
	####################################################

	if control_hint_ui != null:

		if control_hint_ui.has_method("show_hint_movement_only"):

			control_hint_ui.show_hint_movement_only()
