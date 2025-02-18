extends CharacterBody3D

const max_hp = 100
var is_held = false
var in_bowl = true
var current_hp = max_hp

signal holding
signal interacted(body)

@export var prompt_message = "Interact"
@onready var timer: Timer = $Timer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	$"../../FishBowl".connect("bowl_place", Callable(self, "_on_bowl_place"))
	
func interact(body):
	print(body.name, " interacted with ", name)
	interacted.emit(body)

func _on_interacted(body: Variant) -> void:
	is_held = true
	emit_signal("holding")
	prompt_message = ""
	visible = false
	
func _on_bowl_place():
	is_held = false
	visible = true
	prompt_message = "·   E"
	position.z = -4.86

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	print("ON screen")

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	if in_bowl == true:
		timer.start(1)

func _on_timer_timeout() -> void:
	var jump_out_rng = randi_range(1,2)
	if jump_out_rng == 1:
		in_bowl == false
		print("out of bowl")
	else:
		print("still in bowl")
		timer.start(1)
		
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		var random_position := Vector3.ZERO
		random_position.x = randf_range(-5.0, 5.0)
		random_position.z = randf_range(-5.0, 5.0)
		navigation_agent_3d.set_target_position(random_position)
		
func _physics_process(delta: float) -> void:
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	velocity = direction * 5.0
	move_and_slide()
	
	
	
