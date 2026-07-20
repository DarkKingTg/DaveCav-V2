extends CanvasLayer
class_name IntroUI

signal intro_finished

@onready var overlay: ColorRect = $BlackOverlay
@onready var story_label: RichTextLabel = $StoryContainer/StoryLabel

@export var typing_speed := 0.04
@export var line_delay := 1.5
@export var fade_duration := 1.2

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

var is_typing := false
var finished := false


func _ready() -> void:

	hide()

	overlay.visible = true
	overlay.modulate.a = 0.0

	story_label.modulate.a = 0.0
	story_label.text = ""


####################################################
# FADE IN
####################################################

func fade_in() -> void:

	show()

	overlay.modulate.a = 0.0
	story_label.modulate.a = 0.0

	var tween := create_tween()

	tween.tween_property(
		overlay,
		"modulate:a",
		0.65,
		fade_duration
	)

	tween.parallel().tween_property(
		story_label,
		"modulate:a",
		1.0,
		fade_duration
	)

	await tween.finished


####################################################
# FADE OUT
####################################################

func fade_out() -> void:

	var tween := create_tween()

	tween.tween_property(
		overlay,
		"modulate:a",
		0.0,
		fade_duration
	)

	tween.parallel().tween_property(
		story_label,
		"modulate:a",
		0.0,
		fade_duration
	)

	await tween.finished

	hide()


####################################################
# PLAY INTRO
####################################################

func play_intro() -> void:

	finished = false

	story_label.text = ""

	for line in story_lines:

		if line == "":
			story_label.text += "\n"
			continue

		await _type_line(line)

		story_label.text += "\n\n"

		await get_tree().create_timer(line_delay).timeout

	finished = true

	intro_finished.emit()


####################################################
# TYPEWRITER
####################################################

func _type_line(text: String) -> void:

	is_typing = true

	for c in text:

		story_label.text += c

		await get_tree().create_timer(
			typing_speed
		).timeout

	is_typing = false


####################################################
# HELPERS
####################################################

func is_finished() -> bool:
	return finished
