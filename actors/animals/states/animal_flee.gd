extends AnimalState


@export var fleeing_time := 3.5


@onready var flee_timer: Timer = $FleeTimer


func enter(_previous_state_path: String, _data := {}) -> void:
	pick_velocity_away_from_player()
	animal.play_animal_animation("Gallop")
	flee_timer.start(fleeing_time)


func update_physics(_delta: float) -> void:
	animal.look_forward()
	animal.move_and_slide()
	

func pick_velocity_away_from_player() -> void:
	if not is_instance_valid(animal.player):
		state_finished.emit(IDLE)
		return

	var dir := animal.player.global_position.direction_to(animal.global_position)
	animal.velocity = Vector3(dir.x, 0, dir.z) * animal.running_speed


func _on_flee_timer_timeout() -> void:
	state_finished.emit(IDLE)
	return


func exit() -> void:
	flee_timer.stop()