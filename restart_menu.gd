extends Control

func _on_restart_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://main.tscn")

func _on_menu_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://menu.tscn")
