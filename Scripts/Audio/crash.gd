extends RigidBody3D
class_name SoundRigidBody

var collision_occurred = false
var new_crash

@onready var crash_sound = preload("res://Scenes/Audio/crash_sound.tscn")
@onready var wack_sound = preload("res://Scenes/Audio/wet_wack.tscn")

const COLLISION_FIRST = preload("res://Audio/Sound effects/collision_first.wav")
const COLLISION_SECOND = preload("res://Audio/Sound effects/collision_second.wav")



func _ready():
	collision_occurred = false
	contact_monitor = true
	max_contacts_reported = 10

func _physics_process(delta):
	var contacts = get_contact_count()
	if get_contact_count() > 0 and not collision_occurred:
		if "Player" in str(get_colliding_bodies()) or "Fish" in str(get_colliding_bodies()):
			collision_occurred = true
			var crash = crash_sound.instantiate()
			var random = randi_range(1, 2)
			if random == 1:
				crash.stream = COLLISION_FIRST
			else:
				crash.stream = COLLISION_SECOND
			add_child(crash)
			crash.play()
			if "Fish" in str(get_colliding_bodies()):
				var wack = wack_sound.instantiate()
				add_child(wack)
				wack.play()
			await get_tree().create_timer(0.4).timeout
			collision_occurred = false
			
			
	elif get_contact_count() == 0:
		collision_occurred = false
