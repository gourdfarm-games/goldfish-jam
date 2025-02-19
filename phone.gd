extends Interactable

var phone_call
var complete_status = true

func _ready() -> void:
	$"../../TaskManager".connect("task", Callable(self, "_on_task"))
	
func _on_task(task):
	phone_call = task
	complete_status = false
	await get_tree().create_timer(5).timeout
	if complete_status == false:
		print("lose")
		get_tree().paused = true

func _on_interacted(body: Variant) -> void:
	if phone_call == "friend_call":
		complete_status = true
		print("task complete")
