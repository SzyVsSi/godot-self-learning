extends Node


const SETTINGS_SAVE_FILE_PATH := "user://settings.res"


var settings_resource: SettingsResource


func _enter_tree() -> void:
  EventSystem.SET_ask_settings_resource.connect(send_settings_resource)
  EventSystem.SET_save_settings.connect(save_settings)
  EventSystem.SET_change_music_volume.connect(change_music_volume)
  EventSystem.SET_change_sfx_volume.connect(change_sfx_volume)
  EventSystem.SET_change_res_scale.connect(change_res_scale)
  EventSystem.SET_change_ssaa.connect(change_ssaa)
  EventSystem.SET_toggle_fullscreen.connect(toggle_fullscreen)


func _ready() -> void:
  load_settings()
  apply_settings()


func save_settings() -> void:
  ResourceSaver.save(settings_resource, SETTINGS_SAVE_FILE_PATH)


func load_settings() -> void:
  if FileAccess.file_exists(SETTINGS_SAVE_FILE_PATH):
    settings_resource = ResourceLoader.load(SETTINGS_SAVE_FILE_PATH)
  else:
    settings_resource = SettingsResource.new()


func apply_settings() -> void:
  apply_music_volume(settings_resource.music_volume)
  apply_sfx_volume(settings_resource.sfx_volume)
  apply_res_scale(settings_resource.res_scale)
  apply_ssaa(settings_resource.ssaa_enabled)
  apply_fullscreen(settings_resource.fullscreen_enabled)


func send_settings_resource(callback: Callable) -> void:
  callback.call(settings_resource)


func change_music_volume(volume: float) -> void:
  settings_resource.music_volume = volume
  apply_music_volume(volume)


func apply_music_volume(volume: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(volume))


func change_sfx_volume(volume: float) -> void:
  settings_resource.sfx_volume = volume
  apply_sfx_volume(volume)


func apply_sfx_volume(volume: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(volume))


func change_res_scale(scale: float) -> void:
  settings_resource.res_scale = scale
  apply_res_scale(scale)


func apply_res_scale(scale: float) -> void:
  get_viewport().scaling_3d_scale = scale


func change_ssaa(enabled: bool) -> void:
  settings_resource.ssaa_enabled = enabled
  apply_ssaa(enabled)


func apply_ssaa(enabled: bool) -> void:
  get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA if enabled else Viewport.SCREEN_SPACE_AA_DISABLED


func toggle_fullscreen(enabled: bool) -> void:
  settings_resource.fullscreen_enabled = enabled
  apply_fullscreen(enabled)


func apply_fullscreen(enabled: bool) -> void:
  DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED)