extends Interactable

var is_holding = false

@onready var fish: CharacterBody3D = $"../NavigationRegion3D/Fish"

signal bowl_place

func _ready() -> void:
	$"../NavigationRegion3D/Fish".connect("holding", Callable(self, "_on_holding"))
	
func _on_holding():
		is_holding = true
	
func _on_interacted(body: Variant) -> void:
	if is_holding == true and fish.in_bowl == false and fish.is_held == true:
		emit_signal("bowl_place")
	if fish.has_food == true and fish.in_bowl == true:
		fish.feed_fish()
	elif is_holding == false and fish.in_bowl == true:
		is_holding = true
		fish.in_bowl = false
		fish.lose_hp()
		fish.hold_fish()
		
