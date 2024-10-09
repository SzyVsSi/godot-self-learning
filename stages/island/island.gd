extends Node


func _ready() -> void:
	EventSystem.MUS_play_music.emit(MusicConfig.Keys.IslandAmbience)