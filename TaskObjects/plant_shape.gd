extends Interactable

var description_text
var water_progress = 0
var water_complete = true
var water_plant

signal water_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"

func _ready() -> void:
	$"../../TaskManager".connect("task", Callable(self, "_on_task"))

func _on_task(task, description):
	if task == "water_plant":
		description_text = description
		water_plant = task
	
	if water_plant == "water_plant":
		water_complete = false

func _on_interacted(body: Variant) -> void:
	var new_text
	if water_plant == "water_plant":
		if water_progress > 5:
			water_complete = true
			water_progress = 0
			print("task complete")
			new_text = task_label.text.replace(description_text, "")
			task_label.text = new_text
			emit_signal("water_done", task_label.text)
		else:
			water_progress += 1
