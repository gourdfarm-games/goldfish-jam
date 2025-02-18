extends Interactable

var is_holding

signal bowl_place

func _ready() -> void:
	$"../NavigationRegion3D/Fish".connect("holding", Callable(self, "_on_holding"))
	
func _on_holding():
	is_holding = true
	print(is_holding)
	
func _on_interacted(body: Variant) -> void:
	if is_holding == true:
		is_holding = false
		emit_signal("bowl_place")
