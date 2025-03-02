extends Control

@onready var dialogue_track = 0

const next_button = preload("res://Scenes/Dialogue/nextdialogue.tscn")


@onready var dialogue : Dialogue:
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
	dialogue_track = 0
	if dialogue == null:
		dialogue = load("res://Dialogues/0.tres")
		
		call_deferred("cycle_focus")

func update(new_dialogue: Dialogue) -> void:
	%UI.hide()

	%Icon.texture = new_dialogue.texture
	%Name.text = new_dialogue.name
	%Dialogue.text = new_dialogue.dialogue
	reset_options()
	add_buttons(new_dialogue.options)
	
	await get_tree().create_timer(0.5).timeout
	%Options.show()
	%UI.show()
	
	call_deferred("cycle_focus")

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
		button.focus_mode = Control.FOCUS_ALL
		%Options.add_child(button)

#SHOW & HIDE DIALOGUE
func hide_dialogue():
	%UI.hide()

func show_dialogue():
	%UI.show()
	
	
func _input(event):
	if Input.is_action_pressed("hide_dialogue"):
		%UI.hide()
		
func cycle_focus():
	var options = %Options.get_children()
	var current_index = 0
	for i in range(options.size()):
		if options[i].has_focus():
			current_index = i
			break

	var next_index = (current_index + 1) % options.size()
	options[next_index].grab_focus()
