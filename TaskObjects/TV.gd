extends Interactable

var description_text
var watch_tv
var watch_tv_done = true
var watch_time = 0

signal tv_done

@onready var task_label: Label = $"../../PlaceholderHUD/ColorRect/Task"
@onready var player: CharacterBody3D = $"../../Player"
@onready var progress_bar: ProgressBar = $"../../PlaceholderHUD/ColorRect/ProgressBar"

func _ready() -> void:
	$"../../TaskManager".connect("task", Callable(self, "_on_task"))

func _on_task(task, description):
	if task == "watch_tv":
		description_text = description
		watch_tv = task
	
	if watch_tv == "watch_tv":
		watch_tv_done = false

func _on_interacted(body: Variant) -> void:
	var new_text
	if watch_tv == "watch_tv":
		while watch_time < 5 and player.is_moving == false and $VisibleOnScreenNotifier3D.is_on_screen() == true:
			await get_tree().create_timer(0.1).timeout
			watch_time += 0.1
			progress_bar.value = watch_time
			print(watch_time)
		if watch_time >= 5:
			watch_tv_done = true
			watch_time = 0
			print("task complete")
			new_text = task_label.text.replace(description_text, "")
			task_label.text = new_text
			emit_signal("tv_done", task_label.text)
