extends Interactable

var is_watered = true
var watered_progress = 0
var plants_watered = 0

@onready var main_water: StaticBody3D = $"../.."
@onready var plants_to_water: Label = $"../../../../PlaceholderHUD/ColorRect/PlantsToWater"
@onready var plant_pop: AudioStreamPlayer2D = $"../../PlantPop"

func _ready() -> void:
	is_watered = true
	watered_progress = 0
	plants_watered = 0

func need_to_water():
	is_watered = false

func _on_interacted(body: Variant) -> void:
	if is_watered == false:
		if watered_progress > 5:
			is_watered = true
			watered_progress = 0
			main_water.plants_arr.erase(self)
			main_water.plants_watered += 1
			plants_to_water.text = ("Plants to water: " + str(main_water.plants_watered) + "/" + main_water.amount_of_plants)
			if main_water.plants_arr.is_empty() == true:
				main_water.all_plants_done()
			plant_pop.play()
		else:
			watered_progress += 1
