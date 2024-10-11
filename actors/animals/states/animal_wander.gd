extends AnimalState


@export var min_wander_time := 2.0
@export var max_wander_time := 4.0
@export var normal_speed := 0.6


@onready var wander_timer: Timer = $WanderTimer


func enter(_previous_state_path: String, _data := {}) -> void:
	pick_wander_velocity()
	wander_timer.start(randf_range(min_wander_time, max_wander_time))
	animal.play_animal_animation("Walk")


func update_physics(delta: float) -> void:
	animal.look_forward()
	animal.apply_gravity(delta)
	animal.move_and_slide()

	if animal.is_aggressive and animal.can_see_player():
		state_finished.emit(CHASE)


func pick_wander_velocity() -> void:
	var dir := Vector2.UP.rotated(randf() * TAU)
	animal.velocity = Vector3(dir.x, 0, dir.y) * normal_speed


func _on_wander_timer_timeout() -> void:
	state_finished.emit(IDLE)


func exit() -> void:
	wander_timer.stop()