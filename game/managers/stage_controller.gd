extends Node


func _enter_tree() -> void:
	EventSystem.STA_change_stage.connect(change_stage)


func _ready() -> void:
	change_stage(StageConfig.Keys.MainMenu)


func change_stage(key: StageConfig.Keys) -> void:
	for child in get_children():
		child.queue_free()

	var new_stage := StageConfig.get_stage(key)
	add_child(new_stage)
