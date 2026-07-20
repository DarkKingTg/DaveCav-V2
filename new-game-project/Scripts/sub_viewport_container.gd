extends SubViewportContainer

@onready var viewport := $SubViewport

const BASE_SIZE := Vector2i(1280, 720)

func _ready():
	viewport.size = BASE_SIZE
	resized.connect(_update_scale)
	_update_scale()

func _update_scale():
	var window_size = get_viewport().get_visible_rect().size
	scale = window_size / Vector2(BASE_SIZE)
