extends CharacterBody3D

const MAX_HP = 100
const SPEED = 8.0
const HP_LOST_PER_SECOND = 5
const TIME_TO_ESCAPE = 1
const MAX_HUNGER = 100
var current_hp = MAX_HP
var hunger = 25
var is_held = false
var in_bowl = true
var on_screen
var has_food = false

var escape_roll

signal holding
signal interacted(body)
signal hunger_label_update(hunger_level)

@export var prompt_message = "Interact"
@onready var timer: Timer = $InBowlTimer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var region: NavigationRegion3D = $".."
@onready var hunger_label: Label = $"../../../PlaceholderHUD/ColorRect/Hunger"
@onready var game_over_label: Label = $"../../../PlaceholderHUD/ColorRect/GameOver"

func _ready() -> void:
	$"../../FishBowl".connect("bowl_place", Callable(self, "_on_bowl_place"))
	$"../../../TimeManager".connect("hunger_down", Callable(self, "_on_hunger_down"))
	$"../../Food".connect("food_in_hand", Callable(self, "_on_food_in_hand"))
	hunger_label.text = "Hunger: " + str(hunger)

func interact(body):
	interacted.emit(body)

func feed_fish():
	has_food = false
	hunger = MAX_HUNGER
	hunger_label.text = "Hunger: " + str(hunger)
	
func hold_fish():
	is_held = true
	emit_signal("holding")
	prompt_message = ""
	visible = false
	
func _on_interacted(body: Variant) -> void:
	if has_food == true and in_bowl == true:
		feed_fish()	
	else:
		hold_fish()
	
func _on_bowl_place():
	is_held = false
	in_bowl = true
	visible = true
	prompt_message = "·   E"
	velocity = Vector3(0, 0, 0)
	region.enabled = false
	position = Vector3(11.9, 2.63, -4.86)
	

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	on_screen = true

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	on_screen = false
	if on_screen == false:
		if in_bowl == true:
			# Change this to have the initial attempt delay different from the rest
			timer.start(TIME_TO_ESCAPE)
			
# When the player looks away, the fish will attempt to escape
# It has at 50/50 chance to escape
# Each attempt delay is set by the TIME_TO_ESCAPE variable
func attempt_escape():
	if in_bowl == true:
		if on_screen == false:
			escape_roll = randi_range(1, 2)
			if escape_roll == 1:
				in_bowl = false
				region.enabled = true
				fish_move()
				lose_hp()
				print(current_hp)
			elif escape_roll == 2:
				timer.start(TIME_TO_ESCAPE)
		else:
			timer.start(TIME_TO_ESCAPE)
			
	# If fish is out of bowl the same timer is used to degrade hp
	elif in_bowl == false:
		current_hp -= HP_LOST_PER_SECOND
		lose_hp()

func _on_timer_timeout() -> void:
	attempt_escape()
				
	
	
		
		
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
	if in_bowl == false:
		if current_hp <= 0:
			game_over_label.text = "Murphy drowned on air"
			get_tree().paused = true
		else:
			timer.start(1)
	
func _on_hunger_down():
	const HUNGER_LOST_PER_HOUR = 25
	hunger -= HUNGER_LOST_PER_HOUR
	hunger_label.text = "Hunger: " + str(hunger)
	# dies if hunger reaches 0
	if hunger <= 0:
		game_over_label.text = "Murphy died of hunger"
		get_tree().paused = true
		
		
		
func _on_food_in_hand():
	has_food = true
	
	
	
