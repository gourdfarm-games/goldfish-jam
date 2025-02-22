extends Node2D

const next_button = preload("res://NPCS/Murphy/Dialogues/nextdialogue.tscn")

var dialogue : Dialogue:
	set(value):
		dialogue = value
		
		%Icon.texture = value.texture
		%Name.text = value.name
		%Dialogue.text = value.dialogue
		
		reset_options()
		add_buttons(value.options)
		await get_tree().create_timer(0.5).timeout
		%Options.show()
		
#TESTIN
func _ready():
	if dialogue == null:
		dialogue = load("res://NPCS/Murphy/Dialogues/0.tres")

func update(new_dialogue: Dialogue) -> void:
	print("signal")
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
