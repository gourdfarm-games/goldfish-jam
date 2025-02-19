extends Control

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_volume_2_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)





func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
