extends Control


func _on_play_button_up() -> void:
	match Globals.game_mode:
		Globals.GameModes.STREAMER:
			SceneManager.load_scene("menu_twitch")
		_:
			SceneManager.load_scene("main")
