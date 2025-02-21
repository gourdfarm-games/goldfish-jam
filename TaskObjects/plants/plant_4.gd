extends Interactable

var is_watered = true
var watered_progress = 0

@onready var main_water: StaticBody3D = $"../.."

func _ready() -> void:
	pass

func need_to_water():
	is_watered = false

func _on_interacted(body: Variant) -> void:
	if is_watered == false:
		if watered_progress > 5:
			is_watered = true
			watered_progress = 0
			main_water.plants_arr.erase(self)
			print(main_water.plants_arr)
			if main_water.plants_arr.is_empty() == true:
				main_water.all_plants_done()
		else:
			watered_progress += 1
