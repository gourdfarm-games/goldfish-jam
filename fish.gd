extends Interactable


func _on_interacted(body: Variant) -> void:
	var is_held = true

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	print("screen")

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	print("off")
