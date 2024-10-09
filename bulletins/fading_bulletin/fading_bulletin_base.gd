extends Bulletin
class_name FadingBulletin


const BG_NORMAL_COLOR := Color(0, 0, 0, 0.7)
const BG_FADE_TIME := 0.25


@onready var background: ColorRect = $ColorRect


func _ready() -> void:
	EventSystem.HUD_hide_hud.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	fade_in()


func fade_in() -> void:
	create_tween().tween_property(background, "color", BG_NORMAL_COLOR, BG_FADE_TIME)


func fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, BG_FADE_TIME / 2.0)
	tween.tween_callback(destroy_self)


func destroy_self() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.PauseMenu)