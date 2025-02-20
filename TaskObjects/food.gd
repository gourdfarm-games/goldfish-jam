extends Interactable

signal food_in_hand

func _on_interacted(body: Variant) -> void:
	visible = false
	emit_signal("food_in_hand")
