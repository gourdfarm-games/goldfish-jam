extends Node

# Tasks are completed when the task bar is full
# Fill the bar by standing at a task for a certain period of time
# You can leave and come back to a task with the progress saved

# Currently coded so that you only need to interact with object to complete task

@onready var task_label: Label = $"../PlaceholderHUD/ColorRect/Task"

var text_track

signal task(task, description)

func _ready() -> void:
	$"../Greybox/Phone".connect("spam_call_done", Callable(self, "_on_spam_call_done"))
	$"../Greybox/Phone".connect("friend_call_done", Callable(self, "_on_friend_call_done"))
	task_label.text = "Tasks"
	text_track = task_label.text

func _on_timer_timeout() -> void:
	var task = randi_range(1, 1)
	task_roll(task)
		
func task_roll(task):
	var description
	# Friend calls
	if task == 1:
		if $"../Greybox/Phone".friend_call_complete == true and $"../Greybox/Phone".spam_call_complete == true:
			task = "friend_call"
			description = " | Friend is calling"
			task_label.text = text_track + description
			text_track = task_label.text
			emit_signal("task", task, description)
		else:
			task = randi_range(1, 6)
			print(task)
		
	# Spam calls
	elif task == 2: 
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
	
	# Water plant
	elif task == 3: 
		pass
	
	# Mop the floor (if fish has been out enough)
	elif task == 4: 
		pass
		
	# Watch TV
	elif task == 5: 
		pass
	
	# Make your own food
	elif task == 6: 
		pass
		

func _on_spam_call_done(new_text):
	text_track = new_text
	
func _on_friend_call_done(new_text):
	text_track = new_text
	
