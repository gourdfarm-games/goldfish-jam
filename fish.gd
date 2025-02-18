extends Interactable

var is_held = false

signal holding

func _ready() -> void:
	$"../Greybox/FishBowl".connect("bowl_place", Callable(self, "_on_bowl_place"))

func _on_interacted(body: Variant) -> void:
	is_held = true
	emit_signal("holding")
	prompt_message = ""
	visible = false
	
func _on_bowl_place():
	is_held = false
	visible = true
	prompt_message = "·   E"
	position.z = -4.86

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	print("screen")

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	print("off screen")
