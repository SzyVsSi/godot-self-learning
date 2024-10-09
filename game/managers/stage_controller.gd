extends Node


var thread := Thread.new()
var is_stage_changing := false


func _enter_tree() -> void:
	EventSystem.STA_change_stage.connect(start_stage_change_sequence)


func _ready() -> void:
	start_stage_change_sequence(StageConfig.Keys.MainMenu)


func start_stage_change_sequence(key: StageConfig.Keys) -> void:
	if is_stage_changing:
		return

	is_stage_changing = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.GAM_game_fade_in.emit(1.0, game_faded_in.bind(key), true)


func game_faded_in(key: StageConfig.Keys) -> void:
	for child in get_children():
		child.queue_free()

	EventSystem.BUL_destroy_all_bulletins.emit()
	thread.start(load_stage.bind(key))


func load_stage(key: StageConfig.Keys) -> void:
	var new_stage := StageConfig.get_stage(key)
	call_deferred("add_child", new_stage)
	new_stage.loading_complete.connect(stage_loading_complete)
	call_deferred("join_thread")


func stage_loading_complete() -> void:
	EventSystem.GAM_game_fade_out.emit(1.0)
	is_stage_changing = false

func join_thread() -> void:
	thread.wait_to_finish()