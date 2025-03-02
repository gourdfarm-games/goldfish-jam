extends Interactable

var is_open = false
var has_murphy = false

func _ready() -> void:
	is_open = false
	has_murphy = false
	
func _on_interacted(body: Variant) -> void:
	if is_open == false:
		is_open = true
		get_tree().call_group("fridge", "play_anim", "open_fridge")
	elif is_open == true and has_murphy == false:
		is_open = false
		get_tree().call_group("fridge", "play_anim", "close_fridge")
	elif is_open == true and has_murphy == true:
		get_tree().call_group("murphy", "hold_fish")
		has_murphy = false
		
func in_fridge():
	has_murphy = true
