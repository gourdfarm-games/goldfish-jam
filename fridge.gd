extends Interactable

var is_open = false
	
func _on_interacted(body: Variant) -> void:
	if is_open == false:
		is_open = true
		get_tree().call_group("fridge", "play_anim", "open_fridge")
	elif is_open == true:
		is_open = false
		get_tree().call_group("fridge", "play_anim", "close_fridge")
