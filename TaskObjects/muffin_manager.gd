extends Node

var description_text
var muffin_complete = true
var muffin_eat
var muffin_arr = []
var can_eat = false

signal muffin_done
signal all_muffins_done

@onready var task_label: Label = $"../../../../PlaceholderHUD/ColorRect/Task"
@onready var game_over: Label = $"../../../../PlaceholderHUD/ColorRect/GameOver"
@onready var muffin_timer: Timer = $MuffinTimer
@onready var node_3d: Node3D = $"../../../.."

func _ready() -> void:
	muffin_complete = true
	muffin_arr = []
	can_eat = false
	$"../../../../TaskManager".connect("task_muffin", Callable(self, "_on_task"))
	while true:
		await get_tree().create_timer(.1).timeout

func _on_task(task, description):
	if task == "muffin_eat":
		muffin_arr = []
		description_text = description
		muffin_eat = task
		for child in self.find_children("*"):
			if child.is_in_group("Muffins"):
				muffin_arr.append(child)
		get_tree().call_group("Muffins", "can_eat")
	
	if muffin_eat == "muffin_eat":
		muffin_complete = false
		can_eat = true
		
		muffin_timer.start()
		await muffin_timer.timeout
		if muffin_complete == false:
			game_over.text = ("You passed out from starvation")
			await get_tree().create_timer(1).timeout
			node_3d.toggle_restartmenu()
		
func clear_text():
	var new_text
	new_text = task_label.text.replace(description_text, "")
	task_label.text = new_text
	return new_text
		
func eat_a_muffin():
	muffin_timer.stop()
	muffin_complete = true
	can_eat = false
	emit_signal("muffin_done", clear_text())
	
func all_muffins_eaten():
	muffin_timer.stop()
	muffin_complete = true
	emit_signal("all_muffins_done", clear_text())
	
