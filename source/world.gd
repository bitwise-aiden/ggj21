extends TileMap

enum DIRECTION { up = 0, down, left, right }

const PLAYER_TILE_OFFSET = 4
var __offsets = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT,
]

var __player_positions = [Vector2(4,11), Vector2(34,11)]
var __teams = [[],[]]


func _ready() -> void:
	for cell in self.get_used_cells_by_id(0):
		var random: float = randf()

		if random > 0.95:
			self.set_cellv(cell, 1)
		elif random > 0.8:
			self.set_cellv(cell, 3)
		elif random > 0.5:
			self.set_cellv(cell, 2)

	Twitch.connect("move_made", self, "__twitch_move")
	Twitch.connect("player_joined", self, "__player_joined")


func move_player(player_index: int, direction: int):
	var old_position = self.__player_positions[player_index]
	var new_position = old_position + self.__offsets[direction]

	if self.get_cellv(new_position) == INVALID_CELL:
		self.set_cellv(old_position, INVALID_CELL)
		self.set_cellv(new_position, self.PLAYER_TILE_OFFSET + player_index)

		self.__player_positions[player_index] = new_position


func _process(delta: float) -> void:
	if OS.is_debug_build():
		var actions = ["ui_up", "ui_down", "ui_left", "ui_right"]
		for index in range(actions.size()):
			if Input.is_action_just_pressed(actions[index]):
				print(actions[index])
				self.move_player(0, index)


func __get_player_team(username: String) -> int:
	for index in range(self.__teams.size()):
		if self.__teams[index].has(username):
			return index

	return -1


func __player_joined(username: String) -> void:
	if self.__get_player_team(username) != -1:
		return

	var team = 0
	if self.__teams[0].size() > self.__teams[1].size():
		team = 1

	self.__teams[team].append(username)


func __twitch_move(username: String, direction: int) -> void:
	var team = self.__get_player_team(username)
	if team == -1:
		return

	print("%s moved %d for %d" % [username, direction, team])

	self.move_player(team, direction)
