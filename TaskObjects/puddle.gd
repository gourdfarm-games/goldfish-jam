extends Interactable

var mop_floor
var description_text
var mop_progress = 0
var mop_complete = true

signal mop_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"
@onready var game_over: Label = $"../../PlaceholderHUD/ColorRect/GameOver"
@onready var puddle_timer: Timer = $PuddleTimer

func _ready() -> void:
	$"../../TaskManager".connect("task_mop", Callable(self, "_on_task"))
	visible = false

func _on_task(task, description):
	if task == "mop_floor":
		description_text = description
		mop_floor = task
		set_collision_layer_value(2, true)
	
	if mop_floor == "mop_floor":
		mop_complete = false
		
	puddle_timer.start()
	await puddle_timer.timeout
	if mop_complete == false:
		game_over.text = ("puddle failed")
		get_tree().paused = true

func _on_interacted(body: Variant) -> void:
	var new_text
	if mop_floor == "mop_floor":
		if mop_progress > 5:
			puddle_timer.stop()
			mop_complete = true
			set_collision_layer_value(2, false)
			mop_progress = 0
			print("task complete")
			new_text = task_label.text.replace(description_text, "")
			task_label.text = new_text
			emit_signal("mop_done", task_label.text)
		else:
			mop_progress += 1
