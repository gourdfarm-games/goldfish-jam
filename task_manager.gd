extends Node

# Tasks are completed when the task bar is full
# Fill the bar by standing at a task for a certain period of time
# You can leave and come back to a task with the progress saved

@onready var task_label: Label = $"../PlaceholderHUD/ColorRect/Task"

signal task(task)

func _on_timer_timeout() -> void:
	var task = randi_range(1, 1)
	if task == 1: # Friend calls
		task = "friend_call"
		task_label.text = "Task: Friend is calling"
		emit_signal("task", task)
		
	elif task == 2: # Spam calls
		pass
		
	elif task == 3: # Water plant
		pass
		
	elif task == 4: # Mop the floor (if fish has been out enough)
		pass
		
	elif task == 5: # Watch TV
		pass
		
	elif task == 6: # Make your own food
		pass
