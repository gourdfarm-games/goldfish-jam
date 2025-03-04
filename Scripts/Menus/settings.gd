extends Control
@onready var volume_2: HSlider = $VBoxContainer2/Volume2
@onready var volume_3: HSlider = $VBoxContainer2/Volume3
@onready var volume_4: HSlider = $VBoxContainer2/Volume4

func _ready() -> void:
	pass
		

	

func _on_back_pressed() -> void:
	$button.play()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_resolutions_item_selected(index: int) -> void:
	
	match index:
		0: 
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1: 
			DisplayServer.window_set_size(Vector2i(1600,900))
		2: 
			DisplayServer.window_set_size(Vector2i(1280,720))
		3: 
			DisplayServer.window_set_size(Vector2i(2560,1440))
