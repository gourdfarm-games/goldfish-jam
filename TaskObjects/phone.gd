extends Interactable

var friend_call_complete = true
var spam_call_complete = true
var phone_call
var description_text


signal friend_call_done
signal spam_call_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"

func _ready() -> void:
	$"../../TaskManager".connect("task", Callable(self, "_on_task"))
	
func _on_task(task, description):
	description_text = description
	phone_call = task
	
	if phone_call == "friend_call":
		friend_call_complete = false
	elif phone_call == "spam_call":
		spam_call_complete = false

		
	await get_tree().create_timer(5).timeout
	if friend_call_complete == false:
		print("lose")

func _on_interacted(body: Variant) -> void:
	var new_text
	if phone_call == "friend_call":
		friend_call_complete = true
		phone_call = null
		print("task complete")
		new_text = task_label.text.replace(description_text, "")
		task_label.text = new_text
		emit_signal("friend_call_done", task_label.text)
		
	
	elif phone_call == "spam_call":
		spam_call_complete = true
		phone_call = null
		print("task complete")
		new_text = task_label.text.replace(description_text, "")
		task_label.text = new_text
		emit_signal("spam_call_done", task_label.text)
