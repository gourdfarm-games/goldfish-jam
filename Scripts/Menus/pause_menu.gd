extends Control

@onready var resume_button = $VBoxContainer/resume
@onready var main: Node3D = $".."

func _ready():
	visible = false

#func _input(event):
	#if event.is_action_pressed("return-to-menu"):  # Default: Escape key
		#toggle_pause()

#func toggle_pause():
	#if visible:
		#resume_game()
	#else:
		#pause_game()
#
#
#func pause_game():
	#Engine.time_scale = 0  # Pause game logic
	#visible = true
	#resume_button.grab_focus()  # Show pause menu
#
#func resume_game():
	#Engine.time_scale = 1  # Resume normal game speed
	#visible = false  # Hide pause menu

func _on_menu_pressed() -> void:
	$button.play()
	main.toggle_pause()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")




func _on_restart_pressed() -> void:
	$button.play()
	main.toggle_pause()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_resume_pressed() -> void:
	$button.play()
	main.toggle_pause()
