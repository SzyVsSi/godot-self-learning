class_name MusicConfig


enum Keys {
  IslandAmbience
}


const FILE_PATHS := {
  Keys.IslandAmbience: "res://audio/music/island_ambience.ogg"
}


static func get_audio_stream(key: Keys) -> AudioStream:
  return load(FILE_PATHS.get(key))