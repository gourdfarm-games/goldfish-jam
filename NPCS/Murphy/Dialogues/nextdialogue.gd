extends Button


@onready var dialogue_manager = get_node("res://NPCS/Murphy/Dialogues/dialoguemanager.tscn")
var dialogue : Dialogue:
	set(value):
		dialogue = value
		text = dialogue.path_option


func _on_pressed() -> void:
	if dialogue.options.size() == 0:
		dialogue_manager.hide_dialogue()
		return
	
	
	dialogue_manager.dialogue = dialogue
