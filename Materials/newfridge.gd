extends Node3D

@onready var open_fridge: AnimationPlayer = $OpenFridge

func play_anim(anim):
	open_fridge.play(anim)
