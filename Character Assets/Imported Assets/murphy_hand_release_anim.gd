extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player = $AnimationPlayer

func place():
	visible = true
	animation_player.play("MurphyHandsLETITGO")
	await get_tree().create_timer(.5).timeout
	animation_player.play_backwards("MurphyHandsLETITGO")
	visible = false
	get_tree().call_group("hand", "show_hand")
