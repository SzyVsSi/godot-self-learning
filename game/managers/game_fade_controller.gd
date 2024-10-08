extends ColorRect
class_name GameFadeController


func _enter_tree() -> void:
	EventSystem.GAM_game_fade_in.connect(fade_in)
	EventSystem.GAM_game_fade_out.connect(fade_out)


func fade_in(fade_time: float, callback = null) -> void:
	var tween := create_tween()
	tween.tween_property(self, "color", Color.BLACK, fade_time)
	tween.parallel().tween_method(set_master_volume, 1.0, 0.0, fade_time)

	if callback != null and callback is Callable:
		tween.tween_callback(callback)


func fade_out(fade_time: float, callback = null) -> void:
	var tween := create_tween()
	tween.tween_property(self, "color", Color(0, 0, 0, 0), fade_time)
	tween.parallel().tween_method(set_master_volume, 0.0, 1.0, fade_time)

	if callback != null and callback is Callable:
		tween.tween_callback(callback)


func set_master_volume(volume_linear: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume_linear))
