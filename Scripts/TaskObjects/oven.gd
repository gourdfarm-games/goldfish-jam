extends Interactable

var is_open = false
var has_murphy = false
	
func _ready() -> void:
	is_open = false
	has_murphy = false

func _on_interacted(body: Variant) -> void:
	if is_open == false:
		is_open = true
		get_tree().call_group("oven", "play_anim", "open_oven")
	elif is_open == true and has_murphy == false:
		is_open = false
		get_tree().call_group("oven", "play_anim", "close_oven")
	elif is_open == true and has_murphy == true:
		get_tree().call_group("murphy", "hold_fish")
		has_murphy = false
		
func in_oven():
	has_murphy = true
		
