extends Control

func _on_play_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://main.tscn")
	

func _on_settings_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://settings.tscn")

func _on_credits_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://credits.tscn")

func _on_exit_pressed() -> void:
	$button.play()
	get_tree().quit()

@onready var audio_player = $AudioStreamPlayer
