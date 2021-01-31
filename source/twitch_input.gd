class_name TwitchInput extends Gift

var channel: String = ""
var oauth_token: String = ""


func _init(channel, oauth_token) -> void:
	self.channel = channel
	self.oauth_token = oauth_token


func _ready() -> void:
	self.connect("cmd_no_permission", self, "no_permission")
	self.connect_to_twitch()
	yield(self, "twitch_connected")

	self.authenticate_oauth("username", self.oauth_token)
	if(yield(self, "login_attempt") == false):
	  print("Invalid username or token.")
	  return
	self.join_channel(self.channel)

	self.add_command("join", self, "__join")
	self.add_alias("join", "j")

	self.add_command("up", self, "__move_up")
	self.add_command("down", self, "__move_down")
	self.add_command("left", self, "__move_left")
	self.add_command("right", self, "__move_right")

	self.add_alias("up", "u")
	self.add_alias("down", "d")
	self.add_alias("left", "l")
	self.add_alias("right", "r")

	self.add_command("restart", self, "__restart", 0, 0, PermissionFlag.MOD_STREAMER)

	self.chat("Starting game of Chat said what!?")
	self.chat("Type !join to join and !<direction> to move")

	Event.connect("game_starting", self, "__game_starting")


func __game_starting(time_remaining: int) -> void:
	match time_remaining:
		3:
			self.chat("Game starting!")
			continue
		3, 2, 1:
			self.chat("%d..." % time_remaining)
		0:
			self.chat("Go!")


func __join(cmd_info: CommandInfo) -> void:
	Event.emit_signal("player_joined", cmd_info.sender_data.tags["display-name"])


func __move_up(cmd_info: CommandInfo) -> void:
	Event.emit_signal("player_moved", cmd_info.sender_data.tags["display-name"], 0)


func __move_down(cmd_info: CommandInfo) -> void:
	Event.emit_signal("player_moved", cmd_info.sender_data.tags["display-name"], 1)


func __move_left(cmd_info: CommandInfo) -> void:
	Event.emit_signal("player_moved", cmd_info.sender_data.tags["display-name"], 2)


func __move_right(cmd_info: CommandInfo) -> void:
	Event.emit_signal("player_moved", cmd_info.sender_data.tags["display-name"], 3)

func __restart(cmd_info: CommandInfo) -> void:
	self.chat("Aye aye!")
	Event.emit_signal("reload_game")
