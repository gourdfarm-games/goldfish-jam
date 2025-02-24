extends Control

@onready var main = $"../.."
@onready var resume_button = $VBoxContainer/resume

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("return-to-menu"):  # Default: Escape key
		toggle_pause()

func toggle_pause():
	if visible:
		resume_game()
	else:
		pause_game()


func pause_game():
	Engine.time_scale = 0.0  # Pause game logic
	visible = true
	resume_button.grab_focus()  # Show pause menu

func resume_game():
	Engine.time_scale = 1.0  # Resume normal game speed
	visible = false  # Hide pause menu

func _on_menu_pressed() -> void:
	$button.play()
	resume_game()
	get_tree().change_scene_to_file("res://menu.tscn")




func _on_restart_pressed() -> void:
	$button.play()
	resume_game()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_resume_pressed() -> void:
	$button.play()
	resume_game()
