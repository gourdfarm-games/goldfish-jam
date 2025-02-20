extends Node

# Tasks are completed when the task bar is full
# Fill the bar by standing at a task for a certain period of time
# You can leave and come back to a task with the progress saved

@onready var task_label: Label = $"../PlaceholderHUD/ColorRect/Task"

var text_track

signal task(task, description)

func _ready() -> void:
	$"../Greybox/Phone".connect("spam_call_done", Callable(self, "_on_spam_call_done"))
	task_label.text = "Tasks"
	text_track = task_label.text

func _on_timer_timeout() -> void:
	var description
	var task = randi_range(1, 2)
	
	if task == 1: # Friend calls
		task = "friend_call"
		description = " | Friend is calling"
		task_label.text = text_track + description
		text_track = task_label.text
		emit_signal("task", task, description)
		
	elif task == 2: # Spam calls
		var i = 0
		while i < 5:
			task = "spam_call"
			description = " | Spam call"
			task_label.text = text_track + description
			text_track = task_label.text
			emit_signal("task", task, description)
			await $"../Greybox/Phone".spam_call_done
			await get_tree().create_timer(3).timeout
			i += 1
		
	elif task == 3: # Water plant
		pass
		
	elif task == 4: # Mop the floor (if fish has been out enough)
		pass
		
	elif task == 5: # Watch TV
		pass
		
	elif task == 6: # Make your own food
		pass
		
func _on_spam_call_done(new_text):
	text_track = new_text
