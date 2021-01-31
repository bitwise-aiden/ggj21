extends Control

onready var channel = $inputs/channel
onready var oauth_token = $inputs/oauth_token
onready var connect = $connect
onready var connecting = $connecting
onready var error = $error
onready var remember = $remember

func _ready() -> void:
	self.channel.text = SettingsManager.get_setting("twitch/channel", "")
	self.oauth_token.text = SettingsManager.get_setting ("twitch/oauth_token", "")

	if self.channel.text || self.oauth_token.text:
		self.remember.pressed = true

func _on_connect_button_up() -> void:
	self.error.visible = false
	self.connect.disabled = true
	self.connect.visible = false
	self.connecting.visible = true

	if self.remember.pressed:
		SettingsManager.set_setting("twitch/channel", self.channel.text)
		SettingsManager.set_setting("twitch/oauth_token", self.oauth_token.text)
		SettingsManager.save_settings()

	Globals.twitch_input_instance = TwitchInput.new(
		self.channel.text,
		self.oauth_token.text
	)
	Globals.call_deferred("add_child", Globals.twitch_input_instance)

	var success = yield(Globals.twitch_input_instance, "login_attempt")
	if success:
		SceneManager.load_scene("main")
		return

	if Globals.twitch_input_instance:
		Globals.twitch_input_instance.call_deferred("queue_free")
		Globals.twitch_input_instance = null

	self.error.visible = true
	self.connect.disabled = false
	self.connect.visible = true
	self.connecting.visible = false



func _on_menu_button_up() -> void:
	if Globals.twitch_input_instance:
		Globals.twitch_input_instance.call_deferred("queue_free")
		Globals.twitch_input_instance = null

	SceneManager.load_scene("menu_start")

