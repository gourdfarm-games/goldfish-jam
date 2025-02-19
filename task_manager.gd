extends Node

# Tasks are completed when the task bar is full
# Fill the bar by standing at a task for a certain period of time
# You can leave and come back to a task with the progress saved


func _on_timer_timeout() -> void:
	task = randi_range(1, 6)
	if task == 1: # Friend calls
		pass
		
	if task == 2: # Spam calls
		pass
		
	if task == 3: # Water plant
		pass
		
	if task == 4: # Mop the floor (if fish has been out enough)
		pass
		
	if task == 5: # Watch TV
		pass
		
	if task == 6: # Make your own food
		pass
