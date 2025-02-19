extends CharacterBody3D

const MAX_HP = 100
const SPEED = 8.0
const HP_LOST_PER_SECOND = 1
const ESCAPE_ATTEMPT_LAPSE_TIME = 1
const HUNGER_LOST_PER_HOUR = 100
var current_hp = MAX_HP
var hunger = 100
var is_held = false
var in_bowl = false
var on_screen

signal holding(HUNGER_LOST_PER_HOUR)
signal interacted(body)

@export var prompt_message = "Interact"
@onready var timer: Timer = $InBowlTimer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var region: NavigationRegion3D = $".."

func _ready() -> void:
	$"../../FishBowl".connect("bowl_place", Callable(self, "_on_bowl_place"))
	$"../../../TimeManager".connect("hunger_down", Callable(self, "_on_hunger_down"))
	
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
	in_bowl = true
	visible = true
	prompt_message = "·   E"
	velocity = Vector3(0, 0, 0)
	region.enabled = false
	position = Vector3(11.9, 2.63, -4.86)
	

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	print("ON screen")
	on_screen = true

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	print("OFF screen")
	on_screen = false
	if on_screen == false:
		if in_bowl == true:
			timer.start(ESCAPE_ATTEMPT_LAPSE_TIME)
			

func _on_timer_timeout() -> void:
	if in_bowl == true:
		if on_screen == false:
			var jump_out_rng = randi_range(1,1)
			if jump_out_rng == 1:
				in_bowl = false
				print("out of bowl")
				region.enabled = true
				fish_move()
				lose_hp()
			elif on_screen == true:
				pass
			else:
				print("still in bowl")
				timer.start(ESCAPE_ATTEMPT_LAPSE_TIME)
	# If fish is out of bowl, timer is used to degrade hp
	elif in_bowl == false:
		current_hp -= HP_LOST_PER_SECOND
		print(current_hp)
		lose_hp()
		
		
func _physics_process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		fish_move()
		
func fish_move():
	var random_position := Vector3.ZERO
	random_position.x = randf_range(-5.0, 5)
	random_position.z = randf_range(-5.0, 5)
	nav_agent.set_target_position(random_position)

func _on_navigation_agent_3d_navigation_finished() -> void:
	fish_move()
	
func lose_hp():
	timer.start(1)
	
func _on_hunger_down(HUNGER_LOST_PER_HOUR):
	
	hunger -= HUNGER_LOST_PER_HOUR
	# dies if hunger reaches 0
	if hunger <= 0:
		queue_free()
	
	
	
