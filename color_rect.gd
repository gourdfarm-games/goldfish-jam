extends ColorRect





func _ready() -> void:
	var screen_size = DisplayServer.window_get_mode()
	if screen_size == 3:
		pass
