extends Control

func _on_restart_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	Engine.time_scale = 1

func _on_menu_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	Engine.time_scale = 1
