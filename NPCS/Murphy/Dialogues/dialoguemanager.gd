extends Node2D

@export var next_button: PackedScene

var dialogue : Dialogue:
	set(value):
		dialogue = value
		
		%Icon.texture = value.texture
		%Name.text = value.name
		%Dialogue.text = value.dialogue
		
#testing
func _ready():
	dialogue = load("res://NPCS/Murphy/Dialogues/0.tres")
