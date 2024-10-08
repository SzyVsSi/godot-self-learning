extends Camera3D
class_name ShakyCamera


const FREQUENCY_SLOW := 0.00001


var noise := FastNoiseLite.new()


@export var noise_speed := 3.0
@export var noise_multiplier := 0.25


func _ready() -> void:
  noise.seed = randi()
  noise.frequency = noise_speed * FREQUENCY_SLOW


func _process(_delta: float) -> void:
  rotation.x = noise.get_noise_1d(Time.get_ticks_msec()) * noise_multiplier
  rotation.y = noise.get_noise_1d(Time.get_ticks_msec() + 10000) * noise_multiplier