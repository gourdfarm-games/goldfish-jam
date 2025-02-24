extends Node

const GAME_MINUTE = 0.3 # Used to set the in game minute timer
const START_TIME = 9 # Hour that the game starts at
const END_TIME = 17 # Hour that the game ends
var current_hour = START_TIME
var minutes = 0

signal hunger_down

@onready var time: Label = $"../PlaceholderHUD/ColorRect/Time"
@onready var timer: Timer = $Timer
@onready var game_over_label: Label = $"../PlaceholderHUD/ColorRect/GameOver"

func _ready():
	current_hour = START_TIME
	minutes = 0
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
	time.text = "Time is: " + print_time
	
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
		
	if current_hour == END_TIME:
		game_over_label.text = "YOU SURVIVED THE\nDAY WITH MUR"
		get_tree().paused = true
	
