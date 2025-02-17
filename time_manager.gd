extends Node

const GAME_MINUTE = 0.05 # Used to set the in game minute timer
const start_time = 9 # Hour that the game starts at
const end_time = 17 # Hour that the game ends
var current_time = start_time
var minutes = 0

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
	if current_time > 12:
		print_time = str(current_time - 12) + ":" + str(minutes) + "pm"
	else:
		print_time = str(current_time) + ":" + str(minutes) + "am"
	print("Time is: " + print_time)
	#
	# Add functionality to print to hud here
	#
	minutes = int(minutes)
	
	timer.start(GAME_MINUTE)
	if minutes <= 58:
		minutes += 1
		timer.start(GAME_MINUTE)
	else:
		current_time += 1
		minutes = 0
		timer.start(GAME_MINUTE)
		
	# if fish still alive at en
