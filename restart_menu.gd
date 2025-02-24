extends Control

func _on_restart_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://main.tscn")
	Engine.time_scale = 1.0

func _on_menu_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://menu.tscn")
	Engine.time_scale = 1.0
