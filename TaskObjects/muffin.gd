extends Interactable

var is_eaten = true
var eat_progress = 0

@onready var muffin_manager: Node = $".."

func _ready() -> void:
	is_eaten = true
	eat_progress = 0

func can_eat():
	is_eaten = false

func _on_interacted(body: Variant) -> void:
	if muffin_manager.can_eat == true:
		if is_eaten == false:
			if eat_progress > 5:
				is_eaten = true
				eat_progress = 0
				muffin_manager.muffin_arr.erase(self)
				remove_from_group("Muffins")
				queue_free()
				if muffin_manager.muffin_arr.is_empty() == true:
					muffin_manager.all_muffins_eaten()
				else:
					muffin_manager.eat_a_muffin()
			else:
				eat_progress += 1
