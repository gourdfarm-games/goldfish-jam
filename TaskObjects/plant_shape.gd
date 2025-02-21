extends Interactable

var description_text
var watered_progress = 0
var water_complete = true
var water_plant
var plants_arr = []
var total_plants_watered
var can_start_watering = true
var plants_watered = 0

signal water_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"
@onready var game_over: Label = $"../../PlaceholderHUD/ColorRect/GameOver"
@onready var plant_timer: Timer = $PlantTimer
@onready var plants_to_water: Label = $"../../PlaceholderHUD/ColorRect/PlantsToWater"

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
		plants_to_water.text = ("Plants to water: " + str(plants_watered) + "/4")
		get_tree().call_group("Plants", "need_to_water")
	
	if water_plant == "water_plant":
		water_complete = false
		
	plant_timer.start()
	await plant_timer.timeout
	if water_complete == false:
		game_over.text = ("plant failed")
		get_tree().paused = true

func _on_interacted(body: Variant) -> void:
	if water_complete == false:
		if watered_progress > 5:
			water_complete = true
			plants_arr.erase(self)
			print(plants_arr)
			plants_to_water.text = ("Plants to water: " + str(plants_watered) + "/" + str(plants_arr.size()))
			if plants_arr.is_empty() == true:
				all_plants_done()
		else:
			watered_progress += 1
			
func all_plants_done():
	var new_text
	plants_watered = 0
	plants_to_water.text = ""
	plant_timer.stop()
	water_complete = true
	watered_progress = 0
	can_start_watering = true
	print("task complete")
	new_text = task_label.text.replace(description_text, "")
	task_label.text = new_text
	emit_signal("water_done", task_label.text)
