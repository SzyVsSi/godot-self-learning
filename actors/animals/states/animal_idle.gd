extends AnimalState


@export var min_idle_time := 2.0
@export var max_idle_time := 7.0


@onready var idle_timer: Timer = $IdleTimer


func enter(_previous_state_path: String, _data := {}) -> void:
  idle_timer.start(randf_range(min_idle_time, max_idle_time))
  animal.animation_player.animation_finished.connect(animation_finished)
  animal.play_animal_animation(animal.idle_animations.pick_random())


func update_physics(_delta: float) -> void:
  if animal.is_aggressive and animal.can_see_player():
    state_finished.emit(CHASE)


func _on_idle_timer_timeout() -> void:
  state_finished.emit(WANDER)


func animation_finished(_anim_name: String) -> void:
  animal.play_animal_animation(animal.idle_animations.pick_random())


func exit() -> void:
  animal.animation_player.animation_finished.disconnect(animation_finished)
  idle_timer.stop()