extends Node3D
  
@onready var pause_menu = $pausemenu
var paused = false

func _process(delta):
	if Input.is_action_just_pressed("return-to-menu"):
		pauseMenu()
	
func pauseMenu():
	if paused: 
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused

func _unhandled_input(event):
	if Input.is_action_just_pressed("mouse_mode_toggle"):
		var mouse_mode
		if mouse_mode == Input.MOUSE_MODE_VISIBLE: Input.mouse_mode = Input.MOUSE_MODE_CONFINED; 
		elif mouse_mode == Input.MOUSE_MODE_CONFINED: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
		else: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE; 
