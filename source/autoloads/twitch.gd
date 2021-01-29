extends Gift

signal move_made(username, move)
signal player_joined(username)


func _ready() -> void:
	self.connect("cmd_no_permission", self, "no_permission")
	self.connect_to_twitch()
	yield(self, "twitch_connected")


	var channel = SettingsManager.get_setting("twitch/channel")
	var username = SettingsManager.get_setting("twitch/username")
	var oauth_token = SettingsManager.get_setting("twitch/oauth_token")

	self.authenticate_oauth(username, oauth_token)
	if(yield(self, "login_attempt") == false):
	  print("Invalid username or token.")
	  return
	self.join_channel(channel)

	self.add_command("join", self, "__join")

	self.add_command("up", self, "__move_up")
	self.add_command("down", self, "__move_down")
	self.add_command("left", self, "__move_left")
	self.add_command("right", self, "__move_right")

	self.add_alias("up", "u")
	self.add_alias("down", "d")
	self.add_alias("left", "l")
	self.add_alias("right", "r")


func __join(cmd_info: CommandInfo) -> void:
	self.emit_signal("player_joined", cmd_info.sender_data.tags["display-name"])


func __move_up(cmd_info: CommandInfo) -> void:
	self.emit_signal("move_made", cmd_info.sender_data.tags["display-name"], 0)


func __move_down(cmd_info: CommandInfo) -> void:
	self.emit_signal("move_made", cmd_info.sender_data.tags["display-name"], 1)


func __move_left(cmd_info: CommandInfo) -> void:
	self.emit_signal("move_made", cmd_info.sender_data.tags["display-name"], 2)


func __move_right(cmd_info: CommandInfo) -> void:
	self.emit_signal("move_made", cmd_info.sender_data.tags["display-name"], 3)
