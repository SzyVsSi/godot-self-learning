class_name MusicConfig


enum Keys {
  IslandAmbience,
  MainMenuSong
}


const FILE_PATHS := {
  Keys.IslandAmbience: "res://audio/music/island_ambience.ogg",
  Keys.MainMenuSong: "res://audio/music/transfixed_main_theme.ogg"
}


static func get_audio_stream(key: Keys) -> AudioStream:
  return load(FILE_PATHS.get(key))