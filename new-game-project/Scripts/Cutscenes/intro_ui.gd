extends CanvasLayer
class_name IntroUI

signal reveal_world
signal intro_finished

####################################################
# NODES
####################################################

@onready var overlay: ColorRect = $BlackOverlay
@onready var story_container: MarginContainer = $StoryContainer
@onready var story_label: RichTextLabel = $StoryContainer/StoryLabel


####################################################
# SETTINGS
####################################################

@export_group("Typing")
@export var typing_speed := 0.04
@export var line_delay := 1.5
@export var reveal_before_last_lines := 1

@export_group("Fade")
@export var fade_duration := 1.2
@export var overlay_alpha := 0.65

@export_group("Story Animation")
@export var story_move_duration := 1.2
@export var bottom_margin := 80.0

@export_group("Story Fade")
@export var story_fade_duration := 0.5


####################################################
# STORY
####################################################

var story_lines := [
	"Three days ago...",
	"",
	"I received a strange letter.",
	"",
	"It spoke of an abandoned mansion...",
	"",
	"No one who entered ever returned.",
	"",
	"Tonight...",
	"",
	"I'm going to uncover the truth."
]


####################################################
# STATE
####################################################

var finished := false
var is_typing := false

var _story_start_position := Vector2.ZERO


####################################################
# READY
####################################################

func _ready() -> void:

	hide()

	_story_start_position = story_container.position

	overlay.visible = true
	overlay.modulate.a = 0.0

	story_label.text = ""
	story_label.modulate.a = 1.0


####################################################
# FADE IN
####################################################

func fade_in() -> void:

	show()

	overlay.modulate.a = 0.0
	story_label.modulate.a = 1.0

	var tween := create_tween()

	tween.tween_property(
		overlay,
		"modulate:a",
		overlay_alpha,
		fade_duration
	)

	await tween.finished


####################################################
# FADE OUT (ONLY BLACK OVERLAY)
####################################################

func fade_out() -> Tween:

	var tween := create_tween()

	tween.tween_property(
		overlay,
		"modulate:a",
		0.0,
		fade_duration
	)

	return tween


####################################################
# MOVE STORY TO BOTTOM
####################################################

func move_story_to_bottom() -> Tween:

	var tween := create_tween()

	var target := _story_start_position
	target.y += bottom_margin

	tween.tween_property(
		story_container,
		"position",
		target,
		story_move_duration
	)

	return tween


####################################################
# PLAY INTRO
####################################################

func play_intro() -> void:

	finished = false
	is_typing = false

	story_label.text = ""
	story_label.modulate.a = 1.0

	story_container.position = _story_start_position

	for i in range(story_lines.size()):

		var line: String = story_lines[i]

		if line == "":
			story_label.text += "\n"
			continue

		# Reveal world before the final line
		if i == max(0, story_lines.size() - reveal_before_last_lines):
			reveal_world.emit()


		await _type_line(line)

		story_label.text += "\n\n"

		await get_tree().create_timer(line_delay).timeout

	await fade_story()

	finished = true

	intro_finished.emit()


####################################################
# TYPEWRITER
####################################################

func _type_line(text: String) -> void:

	is_typing = true

	for character in text:

		story_label.text += character

		await get_tree().create_timer(
			typing_speed
		).timeout

	is_typing = false


####################################################
# STORY FADE
####################################################

func fade_story() -> void:

	var tween := create_tween()

	tween.tween_property(
		story_label,
		"modulate:a",
		0.0,
		story_fade_duration
	)

	await tween.finished


####################################################
# HELPERS
####################################################

func is_finished() -> bool:
	return finished
