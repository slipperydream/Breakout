extends Panel

signal play_game
signal open_settings

func _on_settings_pressed():
	emit_signal("open_settings")

func _on_play_game_pressed():
	emit_signal("play_game")
	hide()
