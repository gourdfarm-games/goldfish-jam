# This script is not to be applied to a node
# It is used to be inherited from, giving objects the Interactable class
# This will allow objects to be interacted and have their own functionality 

extends CollisionObject3D
class_name Interactable

signal interacted(body)

@export var prompt_message = "Interact"

func interact(body):
	interacted.emit(body)
	
	
