extends Control


const MESSAGES = [
	"Intense 1v1 maze escape using WASD and arrow keys!",
	"Have chat control each team through bot commands!",
	"Connect an external input source, sending UDP packets to port 4242.\n\n(See game page for more info)"
]
const TITLES = [
	"Local",
	"Streamer",
	"External",
]

onready var message = $mode_select/message
onready var not_supported = $mode_select/not_supported
onready var play = $mode_select/play
onready var title = $mode_select/title
onready var images = [
	$mode_select/local,
	$mode_select/streamer,
	$mode_select/external
]


func _ready() -> void:
	if OS.has_feature('JavaScript'):
		JavaScript.eval("document.getElementById('status').style.display = 'none'")

	self.__update_game_mode(0)


func _on_play_button_up() -> void:
	match Globals.game_mode:
		Globals.GameModes.STREAMER:
			SceneManager.load_scene("menu_twitch")
		_:
			SceneManager.load_scene("main")


func _on_left_button_up() -> void:
	self.__update_game_mode(-1)


func _on_right_button_up() -> void:
	self.__update_game_mode(1)


func __update_game_mode(offset: int):
	Globals.game_mode = (Globals.game_mode + Globals.GameModes.MAX + offset) % Globals.GameModes.MAX
	self.message.text = self.MESSAGES[Globals.game_mode]
	self.title.text = self.TITLES[Globals.game_mode]

	for index in range(Globals.GameModes.MAX):
		self.images[index].visible = Globals.game_mode == index

	var is_difficult = Globals.game_mode in [Globals.GameModes.STREAMER, Globals.GameModes.EXTERNAL]
	var is_html = OS.get_name() == "HTML5"
	self.not_supported.visible = is_html && is_difficult
	self.play.visible = !is_html || !is_difficult
