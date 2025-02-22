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
@onready var muffin: Node = $"../Greybox/NavigationRegion3D/FINAL 3D ASSETS/MuffinManager"
@onready var task_delay_timer: Timer = $TaskDelayTimer

var text_track
var task_number
var can_eat_muffin = true
var can_call = true

signal task_call(task, description)
signal task_plant(task, description)
signal task_mop(task, description)
signal task_tv(task, description)
signal task_muffin(task, description)

func _ready() -> void:
	phone.connect("spam_call_done", Callable(self, "_on_spam_call_done"))
	phone.connect("friend_call_done", Callable(self, "_on_friend_call_done"))
	tv.connect("tv_done", Callable(self, "_on_watch_done"))
	plant_shape.connect("water_done", Callable(self, "_on_water_done"))
	puddle.connect("mop_done", Callable(self, "_on_mop_done"))
	muffin.connect("muffin_done", Callable(self, "_on_muffin_done"))
	muffin.connect("all_muffins_done", Callable(self, "_all_muffins_done"))
	
	task_label.text = "Tasks"
	text_track = task_label.text
	task_delay_timer.wait_time = 1
	task_delay_timer.start()

func task_get_rng():
	task_number = randi_range(1, 6)

func _on_timer_timeout() -> void:
	task_get_rng()
	task_roll(task_number)
		
func task_roll(task):
	var description
	var last_task
	# Friend calls
	# Wait for dialogue to end to finish (cant skip through)
	if task == 1 and task != last_task:
		# Phone only rings if no other calls are happening
		if can_call == true:
			if phone.friend_call_complete == true and phone.spam_call_complete == true:
				can_call = false
				task_delay_timer.wait_time = 7
				task_delay_timer.start()
				task = "friend_call"
				description = " | Friend is calling"
				task_label.text = text_track + " | Phone ringing"
				text_track = task_label.text
				emit_signal("task_call", task, description)
			else:
				task = randi_range(1, 6)
		
	# Spam calls
	# Wait for dialogue to end to finish (can skip through?)
	elif task == 2 and task != last_task:
		# Phone only rings if no other calls are happening
		if can_call == true:
			if phone.friend_call_complete == true and phone.spam_call_complete == true:
				can_call = false
				task_delay_timer.wait_time = 7
				task_delay_timer.start()
				var i = 0
				while i < 2:
					task = "spam_call"
					description = " | Spam call"
					task_label.text = text_track + " | Phone ringing"
					text_track = task_label.text
					emit_signal("task_call", task, description)
					await phone.spam_call_done
					await get_tree().create_timer(3).timeout
					i += 1
			else:
				task_get_rng()
	
	# Water plant
	# Spam E a certain amount of times
	elif task == 3 and task != last_task: 
		print(plant_shape.water_complete)
		if plant_shape.can_start_watering == true:
			task_delay_timer.wait_time = 15
			task_delay_timer.start()
			task = "water_plant"
			description = " | You need to water your plants"
			task_label.text = text_track + description
			text_track = task_label.text
			emit_signal("task_plant", task, description)
		else:
			task_get_rng()
	
	# Mop the floor (if fish has been out enough)
	# Pick up mop and clean up water areas
	elif task == 4 and time_of_day.current_hour > 12 and task != last_task: 
		if puddle.mop_complete == true:
			task_delay_timer.wait_time = 5
			task_delay_timer.start()
			puddle.visible = true
			puddle_collision.disabled = false
			task = "mop_floor"
			description = " | Clean up Murphy's mess"
			task_label.text = text_track + description
			text_track = task_label.text
			emit_signal("task_mop", task, description)
		else:
			task_get_rng()
		
	# Watch TV
	# Wait a period of time
	elif task == 5 and task != last_task: 
		if tv.watch_tv_done == true:
			task_delay_timer.wait_time = 12
			task_delay_timer.start()
			task = "watch_tv"
			description = " | Your favorite show is on"
			task_label.text = text_track + description
			text_track = task_label.text
			emit_signal("task_tv", task, description)
		else:
			task_get_rng()
	
	# Make your own food
	# Get all ingredients
	elif task == 6 and task != last_task:
		if can_eat_muffin == true:
			if muffin.muffin_complete == true:
				task_delay_timer.wait_time = 5
				task_delay_timer.start()
				task = "muffin_eat"
				description = " | Eat a muffin"
				task_label.text = text_track + description
				text_track = task_label.text
				emit_signal("task_muffin", task, description)
			else:
				task_get_rng()
	else:
		task_get_rng()
	last_task = task

func _on_spam_call_done(new_text):
	text_track = new_text
	can_call = true
	
func _on_friend_call_done(new_text):
	text_track = new_text
	can_call = true
	
func _on_watch_done(new_text):
	text_track = new_text

func _on_water_done(new_text):
	text_track = new_text
	
func _on_mop_done(new_text):
	puddle.visible = false
	puddle_collision.disabled = true
	text_track = new_text
	
func _on_muffin_done(new_text):
	text_track = new_text
	can_eat_muffin = true

func _all_muffins_done(new_text):
	text_track = new_text
	can_eat_muffin = false
	
