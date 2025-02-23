extends Node3D

@onready var pause_menu = $pausemenu
var paused = false

func _process(delta):
	if Input.is_action_just_pressed("return-to-menu"):
		toggle_pause()

func toggle_pause():
	paused = !paused  
	
	if paused: 
		pause_menu.show()
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	else:
		pause_menu.hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  
