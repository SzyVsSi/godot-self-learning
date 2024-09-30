extends AnimalState


const AFTER_DEATH_TIME := 10.0


@onready var disappear_after_death_timer: Timer = $DisappearAfterDeathTimer


func enter(_previous_state_path: String, _data := {}) -> void:
  animal.main_collision_shape.disabled = true
  animal.play_animal_animation("Death")
  var meat_scene := ItemConfig.get_pickuppable_item(ItemConfig.Keys.RawMeat)
  EventSystem.SPA_spawn_scene.emit(meat_scene, animal.meat_spawn_marker.global_transform)
  animal.set_physics_process(false)
  disappear_after_death_timer.start(AFTER_DEATH_TIME)


func _on_disappear_after_death_timer_timeout() -> void:
  animal.queue_free()
