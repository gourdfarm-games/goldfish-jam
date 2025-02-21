extends Interactable

var description_text
var watered_progress = 0
var water_complete = true
var water_plant
var plants_arr = []
var total_plants_watered
var can_start_watering = true

signal water_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"

func _ready() -> void:
	$"../../TaskManager".connect("task", Callable(self, "_on_task"))
	

func _on_task(task, description):
	if task == "water_plant":
		can_start_watering = false
		description_text = description
		water_plant = task
		plants_arr.append(self)
		for child in self.find_children("*"):
			if child.is_in_group("Plants"):
				plants_arr.append(child)
		print(plants_arr)
		get_tree().call_group("Plants", "need_to_water")
	
	if water_plant == "water_plant":
		water_complete = false

func _on_interacted(body: Variant) -> void:
	if water_complete == false:
		if watered_progress > 5:
			water_complete = true
			plants_arr.erase(self)
			print(plants_arr)
			if plants_arr.is_empty() == true:
				all_plants_done()
		else:
			watered_progress += 1
			
func all_plants_done():
	var new_text
	water_complete = true
	watered_progress = 0
	can_start_watering = true
	print("task complete")
	new_text = task_label.text.replace(description_text, "")
	task_label.text = new_text
	emit_signal("water_done", task_label.text)
