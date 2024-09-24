extends Node


const MAX_ENERGY := 100.0


var current_energy := MAX_ENERGY


func _enter_tree() -> void:
  EventSystem.PLA_change_energy.connect(change_energy)


func change_energy(energy_change: float) -> void:
  current_energy += energy_change
  EventSystem.PLA_update_energy.emit(MAX_ENERGY, current_energy)