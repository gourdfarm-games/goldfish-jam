extends Button

@onready var dialogue_manager = $".."

var dialogue : Dialogue:
	set(value):
		dialogue = value
		text = dialogue.path_option
	
func _ready():
	dialogue_manager = $".."

func _on_pressed() -> void:
	if dialogue.options.size() == 0:
		get_tree().call_group("dialogue", "hide_dialogue")
	else:
		get_tree().call_group("dialogue", "update", dialogue)
		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("next_button_bind"):
		_on_pressed()
