extends VBoxContainer


@onready var energy_bar: TextureProgressBar = $EnergyBar


func _enter_tree() -> void:
  EventSystem.PLA_update_energy.connect(update_energy)


func update_energy(max_energy: float, new_energy: float) -> void:
  energy_bar.max_value = max_energy
  energy_bar.value = new_energy