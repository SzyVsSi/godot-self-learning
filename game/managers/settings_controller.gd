extends Node


func _enter_tree() -> void:
  EventSystem.SET_change_music_volume.connect(change_music_volume)
  EventSystem.SET_change_sfx_volume.connect(change_sfx_volume)
  EventSystem.SET_change_res_scale.connect(change_res_scale)
  EventSystem.SET_change_ssaa.connect(change_ssaa)
  EventSystem.SET_toggle_fullscreen.connect(toggle_fullscreen)


func change_music_volume(volume: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(volume))


func change_sfx_volume(volume: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(volume))


func change_res_scale(scale: float) -> void:
  get_viewport().scaling_3d_scale = scale


func change_ssaa(enabled: bool) -> void:
  get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA if enabled else Viewport.SCREEN_SPACE_AA_DISABLED


func toggle_fullscreen(enabled: bool) -> void:
  DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED)