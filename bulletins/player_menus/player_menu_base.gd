extends Bulletin


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventSystem.PLA_freeze_player.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func close() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.CraftingMenu)
	EventSystem.PLA_unfreeze_player.emit()
