extends Node3D

@onready var open_oven: AnimationPlayer = $OpenOven

func play_anim(anim):
	open_oven.play(anim)
