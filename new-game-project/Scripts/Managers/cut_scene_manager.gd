extends Node
class_name CutSceneManager

signal cutscene_started(cutscene_name: String)
signal cutscene_finished(cutscene_name: String)
signal walk_finished

@export_group("References")
@export var player: CharacterBody2D
@export var camera: Camera2D

@export_group("Settings")
@export var disable_player_controls := true
@export var pause_flashlight := false

var is_cutscene_playing: bool = false
var current_cutscene: String = ""

var _target_reached := false
var _is_walking := false
var _active_target_area: Area2D = null


####################################################
# CUTSCENE START / END
####################################################

func begin_cutscene(cutscene_name: String) -> void:
	if is_cutscene_playing:
		push_warning("Cutscene already running: %s" % current_cutscene)
		return
	is_cutscene_playing = true
	current_cutscene = cutscene_name
	GameState.begin_cutscene()
	_disable_player()
	cutscene_started.emit(current_cutscene)

func end_cutscene() -> void:
	print("END CUTSCENE CALLED")
	if !is_cutscene_playing:
		return

	_enable_player()

	GameState.end_cutscene()

	is_cutscene_playing = false

	cutscene_finished.emit(current_cutscene)

	current_cutscene = ""
	GameState.set_cutscene_active(false)

	print("Cutscene Active:", GameState.is_cutscene_active)


####################################################
# PLAYER AUTO WALK
####################################################

func walk_player_to(target_position: Vector2, arrival_area: Area2D = null) -> void:

	if player == null:
		push_error("CutSceneManager: Player not assigned.")
		return

	if _is_walking:
		push_warning("Player already auto walking.")
		return

	_target_reached = false
	_is_walking = true

	if arrival_area != null:

		_active_target_area = arrival_area

		if !arrival_area.body_entered.is_connected(_on_target_area_body_entered):
			arrival_area.body_entered.connect(_on_target_area_body_entered)

	if player.has_method("start_auto_walk"):
		player.start_auto_walk(target_position)

	while !_target_reached:

		if arrival_area == null:

			if player.global_position.distance_to(target_position) <= 8.0:
				_target_reached = true

		await get_tree().process_frame

	if player.has_method("stop_auto_walk"):
		player.stop_auto_walk()

	if _active_target_area != null:

		if _active_target_area.body_entered.is_connected(_on_target_area_body_entered):
			_active_target_area.body_entered.disconnect(_on_target_area_body_entered)

	_active_target_area = null
	_is_walking = false
	walk_finished.emit()

####################################################
# CAMERA HELPERS
####################################################

func lock_camera() -> void:
	if camera == null:
		return

	camera.enabled = true


func unlock_camera() -> void:
	if camera == null:
		return

	camera.enabled = true

####################################################
# FUTURE PLACEHOLDERS
####################################################

func play_dialogue() -> void:
	pass

func fade_in() -> void:
	pass

func fade_out() -> void:
	pass

func shake_camera() -> void:
	pass

####################################################
# STOP / SKIP CUTSCENE
####################################################

func stop_cutscene() -> void:
	if !is_cutscene_playing:
		return
		
	if player != null and player.has_method("stop_auto_walk"):
		player.stop_auto_walk()
	_target_reached = true
	
	if _active_target_area != null:
		if _active_target_area.body_entered.is_connected(_on_target_area_body_entered):
			_active_target_area.body_entered.disconnect(_on_target_area_body_entered)

	_active_target_area = null
	_is_walking = false
	end_cutscene()
	
func skip_cutscene() -> void:
	stop_cutscene()


####################################################
# PLAYER CONTROL
####################################################
func _disable_player() -> void:

	if player == null:
		return

	if disable_player_controls:

		if player.has_method("set_controls_enabled"):
			player.set_controls_enabled(false)
		else:
			player.controls_enabled = false

	if pause_flashlight:

		var flashlight = player.get_node_or_null("FlashLight")

		if flashlight != null:
			flashlight.set_process(false)


func _enable_player() -> void:
	if player == null:
		return

	if disable_player_controls:
		if player.has_method("set_controls_enabled"):
			player.set_controls_enabled(true)
		else:
			player.controls_enabled = true
			
	if pause_flashlight:

		var flashlight = player.get_node_or_null("FlashLight")

		if flashlight != null:
			flashlight.set_process(true)

####################################################
# STATUS
####################################################
func is_playing() -> bool:
	return is_cutscene_playing
func get_current_cutscene() -> String:
	return current_cutscene

####################################################
# SIGNALS
####################################################
func _on_target_area_body_entered(body: Node2D) -> void:
	if player == null:
		return
	if body != player:
		return
	_target_reached = true

func start_walk(target_position: Vector2, arrival_area: Area2D = null) -> void:

	if _is_walking:
		return

	walk_player_to(target_position, arrival_area)
