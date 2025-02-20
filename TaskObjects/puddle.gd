extends Interactable

var mop_floor
var description_text
var mop_progress = 0
var mop_complete = true

signal mop_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"

func _ready() -> void:
	$"../../TaskManager".connect("task", Callable(self, "_on_task"))
	visible = false

func _on_task(task, description):
	if task == "mop_floor":
		description_text = description
		mop_floor = task
	
	if mop_floor == "mop_floor":
		mop_complete = false

func _on_interacted(body: Variant) -> void:
	var new_text
	if mop_floor == "mop_floor":
		if mop_progress > 5:
			mop_complete = true
			mop_progress = 0
			print("task complete")
			new_text = task_label.text.replace(description_text, "")
			task_label.text = new_text
			emit_signal("mop_done", task_label.text)
		else:
			mop_progress += 1
