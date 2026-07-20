extends Node2D

@onready var intro_manager: IntroManager = $"CutSceneManager/Intro Sequence"

func _ready():
	await get_tree().process_frame
	await intro_manager.play_intro()
