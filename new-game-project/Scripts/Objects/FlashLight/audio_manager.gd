extends Node

@onready var sound = $"../AudioStreamPlayer2D"

func play_toggle():
	sound.play()
