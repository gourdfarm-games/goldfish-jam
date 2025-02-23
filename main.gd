extends Node3D

@onready var pause_menu = $pausemenu
@onready var restart_menu = $restartmenu
var paused = false
var restartmenu = false 

func _process(delta):
	if Input.is_action_just_pressed("return-to-menu"):
		toggle_pause()
	if Input.is_action_just_pressed("restart"):
		toggle_restartmenu()


func toggle_restartmenu():
	restartmenu = !restartmenu
	
	if restartmenu:
		get_tree().change_scene_to_file("res://main.tscn")
	else:
		restart_menu.hide()

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
