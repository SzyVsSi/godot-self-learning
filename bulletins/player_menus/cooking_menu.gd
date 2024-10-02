extends PlayerMenuBase


@onready var starting_cooking_slot: StartingCookingSlot = %StartingCookingSlot
@onready var final_cooking_slot: FinalCookingSlot = %FinalCookingSlot
@onready var cooking_progress_bar: TextureProgressBar = %CookingProgressBar


func _ready() -> void:
	starting_cooking_slot.mouse_entered.connect(show_item_info.bind(starting_cooking_slot))
	starting_cooking_slot.mouse_exited.connect(hide_item_info)
	final_cooking_slot.mouse_entered.connect(show_item_info.bind(final_cooking_slot))
	final_cooking_slot.mouse_exited.connect(hide_item_info)
	super()

func close() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.CookingMenu)
	EventSystem.PLA_unfreeze_player.emit()