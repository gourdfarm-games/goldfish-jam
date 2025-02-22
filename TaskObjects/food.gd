extends Interactable

signal food_in_hand
var in_hand = false

func _on_interacted(body: Variant) -> void:
	visible = false
	in_hand = true
	emit_signal("food_in_hand")
