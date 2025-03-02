extends Interactable

var description_text
var watch_tv
var watch_tv_done = true
var watch_time = 0

signal tv_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"
@onready var player: CharacterBody3D = $"../../Player"
@onready var progress_bar: ProgressBar = $"../../PlaceholderHUD/ColorRect/ProgressBar"
@onready var game_over: Label = $"../../PlaceholderHUD/ColorRect/GameOver"
@onready var tv_timer: Timer = $TVTimer
@onready var node_3d: Node3D = $"../.."

func _ready() -> void:
	watch_tv_done = true
	watch_time = 0
	$"../../TaskManager".connect("task_tv", Callable(self, "_on_task"))

func _on_task(task, description):
	if task == "watch_tv":
		description_text = description
		watch_tv = task
		
	
	if watch_tv == "watch_tv":
		watch_tv_done = false
		progress_bar.value = 0
		progress_bar.visible = true
	
	tv_timer.start()
	await tv_timer.timeout
	if watch_tv_done == false:
		game_over.text = ("You missed you favorite show")
		await get_tree().create_timer(1).timeout
		node_3d.toggle_restartmenu()

func _on_interacted(body: Variant) -> void:
	var new_text
	if watch_tv_done == false:
		if watch_tv == "watch_tv":
			set_collision_layer_value(2, false)
			while watch_time < 5 and player.is_moving == false and $VisibleOnScreenNotifier3D.is_on_screen() == true:
				await get_tree().create_timer(0.1).timeout
				watch_time += 0.1
				progress_bar.value = watch_time
			set_collision_layer_value(2, true)
			if watch_time >= 5:
				tv_timer.stop()
				progress_bar.visible = false
				watch_tv_done = true
				watch_time = 0
				new_text = task_label.text.replace(description_text, "")
				task_label.text = new_text
				emit_signal("tv_done", task_label.text)
