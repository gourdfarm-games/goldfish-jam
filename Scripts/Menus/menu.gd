extends Control

func _on_play_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_settings_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://Scenes/Menus/settings.tscn")
	
func _on_credits_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://Scenes/Menus/credits.tscn")

func _on_exit_pressed() -> void:
	$button.play()
	get_tree().quit()
	
@onready var background_music: AudioStreamPlayer2D = $background_music
