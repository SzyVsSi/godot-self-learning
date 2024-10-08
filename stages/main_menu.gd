extends Node


func _ready() -> void:
	EventSystem.MUS_play_music.emit(MusicConfig.Keys.MainMenuSong)


func _on_start_button_pressed() -> void:
	EventSystem.STA_change_stage.emit(StageConfig.Keys.Island)


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()
