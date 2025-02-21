extends Interactable

var description_text
var watered_progress = 0
var water_complete = true
var water_plant
var plants_arr = [self]
var total_plants_watered

signal water_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"

func _ready() -> void:
	$"../../TaskManager".connect("task", Callable(self, "_on_task"))
	for child in self.find_children("*"):
		if child.is_in_group("Plants"):
			plants_arr.append(child)
	print(plants_arr)

func _on_task(task, description):
	if task == "water_plant":
		description_text = description
		water_plant = task
		get_tree().call_group("Plants", "need_to_water")
	
	if water_plant == "water_plant":
		water_complete = false

func _on_interacted(body: Variant) -> void:
	var new_text
	if water_complete == false:
		if watered_progress > 5:
			water_complete = true
			plants_arr.erase(self)
			print(plants_arr)
		else:
			watered_progress += 1
			
	#if water_progress > 5:
		#water_complete = true
		#water_progress = 0
		#print("task complete")
		#new_text = task_label.text.replace(description_text, "")
		#task_label.text = new_text
		#emit_signal("water_done", task_label.text)
	#else:
		#water_progress += 1
			#
			
func all_plants_done():
	print("yes")
