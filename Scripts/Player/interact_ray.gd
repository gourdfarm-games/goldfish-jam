# Apply the interactable.gd script to a world object to be interactable

extends RayCast3D

@onready var prompt: Label = $Prompt

func _physics_process(_delta):
	prompt.text = ""
	
	
	if is_colliding():
		var collider = get_collider()
		if collider is Interactable or CharacterBody3D:
			prompt.text = "·   E or A"
			
			
			if collider.prompt_message != "Interact":
				prompt.text = collider.prompt_message
				if collider.prompt_message == "·   Mash E":
					prompt.text = "·   Mash E or A"
		
			if Input.is_action_just_pressed("interact"):
				collider.interact(owner)
