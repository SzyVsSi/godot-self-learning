extends FadingBulletin


var open_pause_menu_after_closing := false

@onready var music_volume_slider: HSlider = %MusicVolumeSlider
@onready var sfxvolume_slider: HSlider = %SFXVolumeSlider
@onready var resolution_scale_slider: HSlider = %ResolutionScaleSlider
@onready var ssaacheck_button: CheckButton = %SSAACheckButton
@onready var full_screen_check_button: CheckButton = %FullScreenCheckButton

@onready var music_volume_label: Label = %MusicVolumeLabel
@onready var sfx_volume_label: Label = %SFXVolumeLabel
@onready var resolution_scale_label: Label = %ResolutionScaleLabel


func _ready() -> void:
	EventSystem.SET_ask_settings_resource.emit(set_settings_visuals)

	music_volume_slider.value_changed.connect(_on_music_volume_slider_value_changed)
	sfxvolume_slider.value_changed.connect(_on_sfx_volume_slider_value_changed)
	resolution_scale_slider.value_changed.connect(_on_resolution_scale_slider_value_changed)
	ssaacheck_button.toggled.connect(_on_ssaa_check_button_toggled)
	full_screen_check_button.toggled.connect(_on_full_screen_check_button_toggled)

	super()


func set_settings_visuals(resource: SettingsResource) -> void:
	update_music_volume_label(resource.music_volume)
	music_volume_slider.value = resource.music_volume
	update_sfx_volume_label(resource.sfx_volume)
	sfxvolume_slider.value = resource.sfx_volume
	update_resolution_scale_label(resource.res_scale)
	resolution_scale_slider.value = resource.res_scale
	ssaacheck_button.button_pressed = resource.ssaa_enabled
	full_screen_check_button.button_pressed = resource.fullscreen_enabled


func initialize(_open_pause_menu_after_closing: bool) -> void:
	open_pause_menu_after_closing = _open_pause_menu_after_closing


func _on_music_volume_slider_value_changed(value: float) -> void:
	EventSystem.SET_change_music_volume.emit(value)
	update_music_volume_label(value)


func update_music_volume_label(value: float) -> void:
	music_volume_label.text = str(snappedi(value * 100, 1)) + " %"


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	EventSystem.SET_change_sfx_volume.emit(value)
	update_sfx_volume_label(value)


func update_sfx_volume_label(value: float) -> void:
	sfx_volume_label.text = str(snappedi(value * 100, 1)) + " %"


func _on_resolution_scale_slider_value_changed(value: float) -> void:
	EventSystem.SET_change_res_scale.emit(value)
	update_resolution_scale_label(value)


func update_resolution_scale_label(value: float) -> void:
	resolution_scale_label.text = str(snappedi(value * 100, 1)) + " %"


func _on_ssaa_check_button_toggled(toggled_on: bool) -> void:
	EventSystem.SET_change_ssaa.emit(toggled_on)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)


func _on_full_screen_check_button_toggled(toggled_on: bool) -> void:
	EventSystem.SET_toggle_fullscreen.emit(toggled_on)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)


func _on_close_button_pressed() -> void:
	fade_out()

	EventSystem.SET_save_settings.emit()

	if open_pause_menu_after_closing:
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.PauseMenu)


func destroy_self() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.SettingsMenu)
