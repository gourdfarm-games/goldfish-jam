extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player = $AnimationPlayer
	while true:
		animation_player.play("MurphyIdle_UPDATED_0001")
		await animation_player.animation_finished
		animation_player.play("MurphyIdle_UPDATED_0001")
	
