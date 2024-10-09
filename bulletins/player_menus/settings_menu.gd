extends FadingBulletin


var open_pause_menu_after_closing := false


@onready var music_volume_label: Label = %MusicVolumeLabel
@onready var sfx_volume_label: Label = %SFXVolumeLabel
@onready var resolution_scale_label: Label = %ResolutionScaleLabel


func initialize(_open_pause_menu_after_closing: bool) -> void:
	open_pause_menu_after_closing = _open_pause_menu_after_closing


func _on_music_volume_slider_value_changed(value: float) -> void:
	EventSystem.SET_change_music_volume.emit(value)
	music_volume_label.text = str(snappedi(value * 100, 1)) + " %"


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	EventSystem.SET_change_sfx_volume.emit(value)
	sfx_volume_label.text = str(snappedi(value * 100, 1)) + " %"


func _on_resolution_scale_slider_value_changed(value: float) -> void:
	EventSystem.SET_change_res_scale.emit(value)
	resolution_scale_label.text = str(snappedi(value * 100, 1)) + " %"


func _on_ssaa_check_button_toggled(toggled_on: bool) -> void:
	EventSystem.SET_change_ssaa.emit(toggled_on)


func _on_full_screen_check_button_toggled(toggled_on: bool) -> void:
	EventSystem.SET_toggle_fullscreen.emit(toggled_on)


func _on_close_button_pressed() -> void:
	fade_out()

	if open_pause_menu_after_closing:
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.PauseMenu)


func destroy_self() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.SettingsMenu)
