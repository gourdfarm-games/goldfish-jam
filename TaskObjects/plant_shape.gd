extends Interactable

var description_text
var watered_progress = 0
var water_complete = true
var water_plant
var plants_arr = []
var total_plants_watered
var can_start_watering = true
var plants_watered = 0
var amount_of_plants

signal water_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"
@onready var game_over: Label = $"../../PlaceholderHUD/ColorRect/GameOver"
@onready var plant_timer: Timer = $PlantTimer
@onready var plants_to_water: Label = $"../../PlaceholderHUD/ColorRect/PlantsToWater"
@onready var plant_pop: AudioStreamPlayer2D = $PlantPop
@onready var node_3d: Node3D = $"../.."

func _ready() -> void:
	watered_progress = 0
	water_complete = true
	plants_arr = []
	can_start_watering = true
	plants_watered = 0
	$"../../TaskManager".connect("task_plant", Callable(self, "_on_task"))

func _on_task(task, description):
	if task == "water_plant":
		can_start_watering = false
		description_text = description
		water_plant = task
		plants_arr.append(self)
		for child in self.find_children("*"):
			if child.is_in_group("Plants"):
				plants_arr.append(child)
		amount_of_plants = str(plants_arr.size())
		plants_to_water.text = ("Plants to water: " + str(plants_watered) + "/" + amount_of_plants)
		get_tree().call_group("Plants", "need_to_water")
	
	if water_plant == "water_plant":
		water_complete = false
		
	plant_timer.start()
	await plant_timer.timeout
	if water_complete == false:
		game_over.text = ("Your plants died")
		await get_tree().create_timer(1).timeout
		node_3d.toggle_restartmenu()

func _on_interacted(body: Variant) -> void:
	if water_complete == false:
		if watered_progress > 5:
			water_complete = true
			plants_arr.erase(self)
			plants_watered += 1
			plants_to_water.text = ("Plants to water: " + str(plants_watered) + "/" + amount_of_plants)
			if plants_arr.is_empty() == true:
				all_plants_done()
			plant_pop.play()
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
	new_text = task_label.text.replace(description_text, "")
	task_label.text = new_text
	emit_signal("water_done", task_label.text)
