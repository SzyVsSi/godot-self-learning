extends Node


const MAX_ENERGY := 100.0
const MAX_HEALTH := 100.0


var current_energy := MAX_ENERGY
var current_health := MAX_HEALTH


func _enter_tree() -> void:
  EventSystem.PLA_change_energy.connect(change_energy)
  EventSystem.PLA_change_health.connect(change_health)


func change_energy(energy_change: float) -> void:
  current_energy = clampf(current_energy + energy_change, 0, MAX_ENERGY)

  var out_of_energy = is_zero_approx(current_energy)
  if out_of_energy: change_health(energy_change)
  EventSystem.PLA_update_energy.emit(MAX_ENERGY, 0.0 if out_of_energy else current_energy)


func change_health(health_change: float) -> void:
  current_health = clampf(current_health + health_change, 0, MAX_HEALTH)
  EventSystem.PLA_update_health.emit(MAX_HEALTH, current_health)

  if current_health <= 0:
    EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)
    EventSystem.PLA_freeze_player.emit()