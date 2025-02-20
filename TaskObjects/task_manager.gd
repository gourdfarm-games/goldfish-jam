extends Node

# Tasks are completed when the required actions are completed
# You can leave and come back to a task with the progress saved

# Currently coded so that you only need to interact with object to complete task

@onready var task_label: Label = $"../PlaceholderHUD/ColorRect/Task"

var text_track

signal task(task, description)

func _ready() -> void:
	$"../Greybox/Phone".connect("spam_call_done", Callable(self, "_on_spam_call_done"))
	$"../Greybox/Phone".connect("friend_call_done", Callable(self, "_on_friend_call_done"))
	$"../Greybox/TV".connect("tv_done", Callable(self, "_on_watch_done"))
	$"../PlantShape".connect("water_done", Callable(self, "_on_water_done"))
	
	task_label.text = "Tasks"
	text_track = task_label.text

func _on_timer_timeout() -> void:
	var task = randi_range(3, 3)
	task_roll(task)
		
func task_roll(task):
	var description
	# Friend calls
	# Wait for dialogue to end to finish (cant skip through)
	if task == 1:
		# Phone only rings if no other calls are happening
		if $"../Greybox/Phone".friend_call_complete == true and $"../Greybox/Phone".spam_call_complete == true:
			task = "friend_call"
			description = " | Friend is calling"
			task_label.text = text_track + description
			text_track = task_label.text
			emit_signal("task", task, description)
		else:
			task = randi_range(1, 6)
		
	# Spam calls
	# Wait for dialogue to end to finish (can skip through?)
	elif task == 2:
		# Phone only rings if no other calls are happening
		if $"../Greybox/Phone".friend_call_complete == true and $"../Greybox/Phone".spam_call_complete == true:
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
		else:
			task = randi_range(1, 6)
	
	# Water plant
	# Spam E a certain amount of times
	elif task == 3: 
		if $"../PlantShape".water_complete == true:
			task = "water_plant"
			description = " | You need to water your plant"
			task_label.text = text_track + description
			text_track = task_label.text
			emit_signal("task", task, description)
		else:
			task = randi_range(1, 6)
	
	# Mop the floor (if fish has been out enough)
	# Pick up mop and clean up water areas
	elif task == 4: 
		pass
		
	# Watch TV
	# Wait a period of time
	elif task == 5: 
		if $"../Greybox/TV".watch_tv_done == true:
			task = "watch_tv"
			description = " | Your favorite show is on"
			task_label.text = text_track + description
			text_track = task_label.text
			emit_signal("task", task, description)
		else:
			task = randi_range(1, 6)
	
	# Make your own food
	# Get all ingredients
	elif task == 6: 
		pass
		

func _on_spam_call_done(new_text):
	text_track = new_text
	
func _on_friend_call_done(new_text):
	text_track = new_text
	
func _on_watch_done(new_text):
	text_track = new_text

func _on_water_done(new_text):
	text_track = new_text
	
