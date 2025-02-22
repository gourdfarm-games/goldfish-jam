extends Node2D

@export var next_button: PackedScene

var _dialogue: Dialogue

var dialogue: Dialogue:
	set(value):
		_dialogue = value
		update_dialogue(value)
	get:
		return _dialogue
		
#TESTIN
func _ready():
	if dialogue == null:
		dialogue = load("res://NPCS/Murphy/Dialogues/0.tres")

func update_dialogue(new_dialogue: Dialogue) -> void:
	%UI.hide()

	%Icon.texture = new_dialogue.texture
	%Name.text = new_dialogue.name
	%Dialogue.text = new_dialogue.dialogue
	reset_options()
	add_buttons(new_dialogue.options)
	
	await get_tree().create_timer(0.5).timeout
	%Options.show()
	%UI.show()

#HIDE OPTIONS
func reset_options():
	for child in %Options.get_children():
		child.queue_free()
	%Options.hide()


#FOR ADDING BUTTONS
func add_buttons(options):
	for option in options:
		var button = next_button.instantiate()
		button.dialogue = option
		%Options.add_child(button)

#SHOW & HIDE DIALOGUE
func hide_dialogue():
	%UI.hide()

func show_dialogue():
	%UI.show()
	
	
func _input(event):
	if Input.is_action_pressed("hide_dialogue"):
		%UI.hide()
