# Apply the interactable.gd script to a world object to be interactable

extends RayCast3D

@onready var prompt: Label = $Prompt

func _physics_process(_delta):
	prompt.text = ""
	
	if is_colliding():
		var collider = get_collider()
		
		if collider is Interactable:
			prompt.text = "·   E"
			
			# Enable this if you want each interactable object to have a different prompt
			# The prompt message for each object is changed in the inspector
			#
			# prompt.text = collider.prompt_message
		
			if Input.is_action_just_pressed("interact"):
				collider.interact(owner)
