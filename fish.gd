extends CharacterBody3D

const MAX_HP = 100
const SPEED = 8.0
const HP_LOST_PER_SECOND = 1
const TIME_TO_ESCAPE = 1
const MAX_HUNGER = 100
var current_hp = MAX_HP
var hunger = 25
var is_held = false
var in_bowl = true
var on_screen
var has_food = false

signal holding
signal interacted(body)
signal hunger_label_update(hunger_level)

@export var prompt_message = "Interact"
@onready var timer: Timer = $InBowlTimer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var region: NavigationRegion3D = $".."
@onready var hunger_label: Label = $"../../../PlaceholderHUD/ColorRect/Hunger"

func _ready() -> void:
	$"../../FishBowl".connect("bowl_place", Callable(self, "_on_bowl_place"))
	$"../../../TimeManager".connect("hunger_down", Callable(self, "_on_hunger_down"))
	$"../../Food".connect("food_in_hand", Callable(self, "_on_food_in_hand"))
	hunger_label.text = "Hunger: " + str(hunger)

func interact(body):
	print(body.name, " interacted with ", name)
	interacted.emit(body)

func _on_interacted(body: Variant) -> void:
	if has_food == true and in_bowl == true:
		has_food = false
		hunger = MAX_HUNGER
		hunger_label.text = "Hunger: " + str(hunger)
		
	else:
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
			timer.start(TIME_TO_ESCAPE)
			

func _on_timer_timeout() -> void:
	if in_bowl == true:
		if on_screen == false:
			await get_tree().create_timer(1)
			if on_screen == false:
				in_bowl = false
				print("out of bowl")
				region.enabled = true
				fish_move()
				lose_hp()
			elif on_screen == true:
				pass
			else:
				print("still in bowl")
				timer.start(TIME_TO_ESCAPE)
	# If fish is out of bowl, timer is used to degrade hp
	elif in_bowl == false:
		current_hp -= HP_LOST_PER_SECOND
		print(current_hp)
		lose_hp()
		
		
func _physics_process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = velocity.move_toward(new_velocity, .5)
	move_and_slide()
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		fish_move()
		
func fish_move():
	var random_position := Vector3.ZERO
	random_position.x = randf_range(-10.0, 10.0)
	random_position.z = randf_range(-10.0, 10.0)
	nav_agent.set_target_position(random_position)

func _on_navigation_agent_3d_navigation_finished() -> void:
	fish_move()
	
func lose_hp():
	if current_hp <= 0:
		queue_free()
	else:
		timer.start(1)
	
func _on_hunger_down():
	const HUNGER_LOST_PER_HOUR = 25
	hunger -= HUNGER_LOST_PER_HOUR
	print(hunger)
	hunger_label.text = "Hunger: " + str(hunger)
	# dies if hunger reaches 0
	if hunger <= 0:
		queue_free()
		
		
func _on_food_in_hand():
	has_food = true
	
	
	
