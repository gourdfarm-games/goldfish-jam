extends Node

var description_text
var muffin_complete = true
var muffin_eat
var muffin_arr = []

signal muffin_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"

func _ready() -> void:
	$"../../TaskManager".connect("task", Callable(self, "_on_task"))

func _on_task(task, description):
	if task == "muffin_eat":
		description_text = description
		muffin_eat = task
		muffin_arr.append(self)
		for child in self.find_children("*"):
			if child.is_in_group("Muffins"):
				muffin_arr.append(child)
		print(muffin_arr)
		get_tree().call_group("Muffins", "can_eat")
	
	if muffin_eat == "muffin_eat":
		muffin_complete = false
		
func eat_a_muffin():
	var new_text
	muffin_complete = true
	new_text = task_label.text.replace(description_text, "")
	task_label.text = new_text
	emit_signal("muffin_done")
	
func all_muffins_eaten():
	emit_signal("all_muffins_done")
