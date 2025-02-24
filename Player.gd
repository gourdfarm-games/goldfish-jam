extends CharacterBody3D

var speed 
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 10
const FALL_SPEED = 30

const SENSITIVITY = 0.003
const DEADZONE = 0.2
const MAX_UP_ANGLE = 50
const MAX_DOWN_ANGLE = -50

const BOB_FREQ = 2.0
const BOB_AMP = 0.09
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const SPRINT_FOV = 90.0
const FOV_CHANGE_SPEED = 5.0

var joy_input = Vector2.ZERO

var is_moving

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var player_steps: AudioStreamPlayer3D = $PlayerSteps
@onready var fish: CharacterBody3D = $"../Greybox/NavigationRegion3D/Fish"
@onready var interact_ray: RayCast3D = $Head/Camera3D/InteractRay

func _ready():
	joy_input = Vector2.ZERO
	t_bob = 0.0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event): #CAM MOVEMENT BASED ON MOUSE
	#CAM MOVEMENT BASED ON MOUSE 
	if event is InputEventMouseMotion:
		
		head.rotate_y(-event.relative.x * SENSITIVITY)
		
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
func _process(delta): # CAM MOVEMENT BASED ON JOYSTICK
	# CAM MOVEMENT BASED ON JOYSTICK
	var right_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var right_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	
	if abs(right_x) < DEADZONE:
		right_x = 0
	if abs(right_y) < DEADZONE:
		right_y = 0
	
	if right_x != 0:
		head.rotate_object_local(Vector3.UP, -right_x * SENSITIVITY * delta * 1500)
	
	if right_y != 0:
		
		var current_rotation = head.rotation_degrees.x
		
		var new_rotation = current_rotation - right_y * SENSITIVITY * delta * 60000
		
		new_rotation = clamp(new_rotation, MAX_DOWN_ANGLE, MAX_UP_ANGLE)
		
		head.rotation_degrees.x = new_rotation
		head.rotation.z = 0
		
	if head:
		head.rotation.z = 0
		
func _physics_process(delta: float) -> void: #DEFAULT MOVEMENT
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	
	if not is_on_floor():
		velocity.y = velocity.y - (FALL_SPEED * delta)
		
	if Input.is_action_pressed("sprint"):
		player_steps.pitch_scale = 1.8
		speed = SPRINT_SPEED
		camera.fov = lerp(camera.fov, SPRINT_FOV, FOV_CHANGE_SPEED * delta)
	else:
		speed = WALK_SPEED
		camera.fov = lerp(camera.fov, BASE_FOV, FOV_CHANGE_SPEED * delta)
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var forward_dir = -head.transform.basis.z.normalized()
	var right_dir = head.transform.basis.x.normalized()
	var direction = (right_dir * input_dir.x - forward_dir * input_dir.y).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		is_moving = true
		if player_steps.playing == false:
			player_steps.pitch_scale = 1.3
			player_steps.play()
		
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		is_moving = false
		player_steps.stop()
		
#Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()

func _headbob(time) -> Vector3: #HEADBOB
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos 


func _on_plant_2_interacted(body: Variant) -> void:
	pass # Replace with function body.
