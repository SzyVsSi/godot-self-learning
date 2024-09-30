extends AnimalState


func enter(_previous_state_path: String, _data := {}) -> void:
	animal.animation_player.animation_finished.connect(animation_finished)
	animal.play_animal_animation("Attack")


func update_physics(_delta: float) -> void:
	var dir := animal.global_position.direction_to(animal.player.global_position)
	animal.rotation.y = lerp_angle(animal.rotation.y, atan2(dir.x, dir.z) + PI, animal.turn_speed_weight)


func animation_finished(_anim_name: String) -> void:
	state_finished.emit(CHASE)
	

func exit() -> void:
	animal.animation_player.animation_finished.disconnect(animation_finished)