extends FadingBulletin


const BUTTON_FADE_TIME := 0.15


@onready var resume_button: Button = $VBoxContainer/ResumeButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var exit_button: Button = $VBoxContainer/ExitButton


func _ready() -> void:
	resume_button.modulate = Color.TRANSPARENT
	settings_button.modulate = Color.TRANSPARENT
	exit_button.modulate = Color.TRANSPARENT
	get_tree().paused = true
	super()


func fade_in() -> void:
	super()
	var tween := create_tween()
	tween.tween_property(resume_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)
	tween.tween_property(settings_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)
	tween.tween_property(exit_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)


func _on_exit_button_pressed() -> void:
	EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)


func _on_settings_button_pressed() -> void:
	fade_out()
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SettingsMenu, true)


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fade_out()
	EventSystem.HUD_show_hud.emit()
