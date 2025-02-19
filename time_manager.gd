extends Node

const GAME_MINUTE = 0.05 # Used to set the in game minute timer
const START_TIME = 9 # Hour that the game starts at
const END_TIME = 17 # Hour that the game ends
var current_hour = START_TIME
var minutes = 0

signal hunger_down

@onready var timer: Timer = $Timer

func _ready():
	timer.start(0.05)
	
func _on_timer_timeout() -> void:
	var print_time
	if minutes < 10:
		minutes = "0" + str(minutes)
	else:
		minutes = str(minutes)
	
	# Converts 24hr time to 12hr time
	if current_hour > 12:
		print_time = str(current_hour - 12) + ":" + str(minutes) + "pm"
	else:
		print_time = str(current_hour) + ":" + str(minutes) + "am"
	#print("Time is: " + print_time)
	#
	# Add functionality to print to hud here
	#
	minutes = int(minutes)
	
	timer.start(GAME_MINUTE)
	if minutes <= 58:
		minutes += 1
		timer.start(GAME_MINUTE)
	else:
		emit_signal("hunger_down")
		current_hour += 1
		minutes = 0
		timer.start(GAME_MINUTE)
		
	
