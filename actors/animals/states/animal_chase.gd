extends AnimalState


func enter(_previous_state_path: String, _data := {}) -> void:
  animal.play_animal_animation("Gallop")


func update_physics(delta: float) -> void:
  if animal.global_position.distance_to(animal.player.global_position) <= animal.attack_distance:
    state_finished.emit(ATTACK)
    return

  animal.nav_agent.target_position = animal.player.global_position
  var dir := animal.global_position.direction_to(animal.nav_agent.get_next_path_position())
  animal.velocity = Vector3(dir.x, 0, dir.z) * animal.running_speed
  animal.look_forward()
  animal.apply_gravity(delta)
  animal.move_and_slide()