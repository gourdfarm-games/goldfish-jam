extends Node

# Tasks are completed when the required actions are completed
# You can leave and come back to a task with the progress saved

# Currently coded so that you only need to interact with object to complete task

# Normal node variables
@onready var task_label: Label = $"../PlaceholderHUD/ColorRect/Task"
@onready var time_of_day: Node = $"../TimeManager"
@onready var puddle_collision: CollisionShape3D = $"../Greybox/Puddle/CollisionShape3D"

# Task node variables
@onready var phone: StaticBody3D = $"../Greybox/Phone"
@onready var tv: StaticBody3D = $"../Greybox/TV"
@onready var plant_shape: StaticBody3D = $"../Greybox/PlantShape"
@onready var puddle: StaticBody3D = $"../Greybox/Puddle"


var text_track

signal task(task, description)

func _ready() -> void:
	phone.connect("spam_call_done", Callable(self, "_on_spam_call_done"))
	phone.connect("friend_call_done", Callable(self, "_on_friend_call_done"))
	tv.connect("tv_done", Callable(self, "_on_watch_done"))
	plant_shape.connect("water_done", Callable(self, "_on_water_done"))
	puddle.connect("mop_done", Callable(self, "_on_mop_done"))
	
	task_label.text = "Tasks"
	text_track = task_label.text

func _on_timer_timeout() -> void:
	var task = randi_range(1, 5)
	task_roll(task)
		
func task_roll(task):
	var description
	print("initial: " + str(task))
	# Friend calls
	# Wait for dialogue to end to finish (cant skip through)
	if task == 1:
		print("post roll: " + str(task))
		# Phone only rings if no other calls are happening
		if phone.friend_call_complete == true and phone.spam_call_complete == true:
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
		print("post roll: " + str(task))
		# Phone only rings if no other calls are happening
		if phone.friend_call_complete == true and phone.spam_call_complete == true:
			var i = 0
			while i < 5:
				task = "spam_call"
				description = " | Spam call"
				task_label.text = text_track + description
				text_track = task_label.text
				emit_signal("task", task, description)
				await phone.spam_call_done
				await get_tree().create_timer(3).timeout
				i += 1
		else:
			task = randi_range(1, 6)
	
	# Water plant
	# Spam E a certain amount of times
	elif task == 3: 
		print("post roll: " + str(task))
		print(plant_shape.water_complete)
		if plant_shape.water_complete == true:
			task = "water_plant"
			description = " | You need to water your plant"
			task_label.text = text_track + description
			text_track = task_label.text
			emit_signal("task", task, description)
		else:
			task = randi_range(1, 6)
	
	# Mop the floor (if fish has been out enough)
	# Pick up mop and clean up water areas
	elif task == 4 and time_of_day.current_hour < 12: 
		print("post roll: " + str(task))
		if puddle.mop_complete == true:
			puddle.visible = true
			puddle_collision.disabled = false
			task = "mop_floor"
			description = " | Clean up Murphy's mess"
			task_label.text = text_track + description
			text_track = task_label.text
			emit_signal("task", task, description)
		else:
			task = randi_range(1, 6)
		
	# Watch TV
	# Wait a period of time
	elif task == 5: 
		print("post roll: " + str(task))
		if tv.watch_tv_done == true:
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
	
func _on_mop_done(new_text):
	puddle.visible = false
	puddle_collision.disabled = true
	text_track = new_text
	
