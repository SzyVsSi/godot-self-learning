extends AnimalState


func enter(_previous_state_path: String, _data := {}) -> void:
  animal.animation_player.animation_finished.connect(animation_finished)
  animal.play_animal_animation(animal.hurt_animations.pick_random())


func animation_finished(_anim_name: String) -> void:
  if animal.is_aggressive:
    state_finished.emit(CHASE)
  else:
    state_finished.emit(FLEE)


func exit() -> void:
  animal.animation_player.animation_finished.disconnect(animation_finished)