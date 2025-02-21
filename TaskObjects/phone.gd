extends Interactable

var friend_call_complete = true
var spam_call_complete = true
var phone_call
var description_text

signal friend_call_done
signal spam_call_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"
@onready var game_over: Label = $"../../PlaceholderHUD/ColorRect/GameOver"
@onready var phone_timer: Timer = $PhoneTimer


func _ready() -> void:
	$"../../TaskManager".connect("task_call", Callable(self, "_on_task"))
	
func _on_task(task, description):
	if task == "friend_call" or task == "spam_call":
		description_text = description
		phone_call = task
		if phone_call == "friend_call":
			friend_call_complete = false
		elif phone_call == "spam_call":
			spam_call_complete = false
		phone_timer.start()
		await phone_timer.timeout
		if friend_call_complete == false or spam_call_complete == false:
			game_over.text = ("call failed")
			get_tree().paused = true
	
	
	

func _on_interacted(body: Variant) -> void:
	var new_text
	if phone_call == "friend_call":
		phone_timer.stop()
		friend_call_complete = true
		print("task complete")
		new_text = task_label.text.replace(description_text, "")
		task_label.text = new_text
		emit_signal("friend_call_done", task_label.text)
		
	
	elif phone_call == "spam_call":
		phone_timer.stop()
		spam_call_complete = true
		print("task complete")
		new_text = task_label.text.replace(description_text, "")
		task_label.text = new_text
		emit_signal("spam_call_done", task_label.text)
