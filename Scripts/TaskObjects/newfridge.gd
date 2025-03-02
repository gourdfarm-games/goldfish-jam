extends Node3D

@onready var open_fridge: AnimationPlayer = $OpenFridge

func _ready() -> void:
	open_fridge = $OpenFridge

func play_anim(anim):
	open_fridge.play(anim)
