extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal anim_grabbed

func _ready() -> void:
	animation_player = $AnimationPlayer

func pickup():
	visible = true
	animation_player.play("MurphyHandsGrabbing")
	await get_tree().create_timer(.2).timeout
	animation_player.play_backwards("MurphyHandsGrabbing")
	await animation_player.animation_finished
	visible = false
	get_tree().call_group("hand", "show_hand")
