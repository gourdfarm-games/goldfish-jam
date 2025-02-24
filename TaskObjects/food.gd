extends Interactable

var in_hand = false
var food_tracker = 0

signal food_in_hand

@onready var player: CharacterBody3D = $"../../Player"
@onready var interact_ray: RayCast3D = $"../../Player/Head/Camera3D/InteractRay"
@onready var drop_label: Label = $"../../PlaceholderHUD/ColorRect/Drop"
@onready var fish: CharacterBody3D = $"../NavigationRegion3D/Fish"

func _ready() -> void:
	in_hand = false
	food_tracker = 0
	fish.connect("destory_food", Callable(self, "_on_destory_food"))

func _on_interacted(body: Variant) -> void:
	drop_label.text = "Q/B to Drop Food"
	visible = false
	set_collision_layer_value(2, false)
	in_hand = true
	self.set_name(str(food_tracker))
	emit_signal("food_in_hand")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop_food"):
		drop_label.text = ""
		in_hand = false
		visible = true
		set_collision_layer_value(2, true)
		if self.name == str(food_tracker):
			var drop_offset = Vector3(0, 0, 2)
			global_position = interact_ray.global_position - interact_ray.global_transform.basis.z
			food_tracker += 1
			
func _on_destory_food():
	if self.name == str(food_tracker):
		drop_label.text = ""
		queue_free()
