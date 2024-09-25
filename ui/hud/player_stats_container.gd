extends VBoxContainer


@onready var energy_bar: TextureProgressBar = $EnergyBar
@onready var health_bar: TextureProgressBar = $HealthBar

func _enter_tree() -> void:
  EventSystem.PLA_update_energy.connect(update_energy)
  EventSystem.PLA_update_health.connect(update_health)


func update_energy(max_energy: float, new_energy: float) -> void:
  energy_bar.max_value = max_energy
  energy_bar.value = new_energy


func update_health(max_health: float, new_health: float) -> void:
  health_bar.max_value = max_health
  health_bar.value = new_health