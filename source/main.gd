extends TileMap

enum DIRECTION { up = 0, down, left, right }

const DIRECTION_OFFSETS: Array = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT,
]
const DIRECTION_NAMES: Array = [
	"up",
	"down",
	"left",
	"right"
]
const MESSAGE_MOVE_FORMAT: String = "%s - %s"
const MESSAGE_JOIN_FORMAT: String = "%s joined!"
const TEAM_COLORS: Array = [
	Color("c7a290"),
	Color("948ec9")
]
const TEAM_TILES: Array = [
	4,
	5
]

onready var countdown = $countdown
onready var team_messages: Array = [
	$red_team,
	$blue_team
]

var __playing = false
var __team_positions: Array = [Vector2(4,11), Vector2(34,11)]
#var __team_positions: Array = [Vector2(17,10), Vector2(21,10)]
var __teams: Array = [[],[]]
var __valid_fill_tiles: Array = [INVALID_CELL]


func _ready() -> void:
	match Globals.game_mode:
		Globals.GameModes.LOCAL:
			var instance = LocalInput.new()
			self.call_deferred("add_child", instance)
		Globals.GameModes.EXTERNAL:
			var instance = ExternalInput.new()
			self.call_deferred("add_child", instance)


	for cell in self.get_used_cells_by_id(0):
		var random: float = randf()

		if random > 0.95:
			self.set_cellv(cell, 1)
		elif random > 0.8:
			self.set_cellv(cell, 3)
		elif random > 0.5:
			self.set_cellv(cell, 2)

	for cell in self.get_used_cells_by_id(7):
		var flip_x: bool = cell.x == 1.0
		var flip_y: bool = cell.y == 1.0
		var transpose: bool = cell.y != 1.0 and cell.y != 20

		self.set_cellv(cell, randi() % 4 + 7, flip_x, flip_y, transpose)

	for cell in self.get_used_cells_by_id(11):
		var flip_x: bool = false
		var flip_y: bool = false

		match cell:
			Vector2(1.0, 20.0):
				flip_x = true
			Vector2(1.0, 1.0):
				flip_x = true
				flip_y = true
			Vector2(37.0, 1.0):
				flip_y = true

		self.set_cellv(cell, 11, flip_x, flip_y)

	for cell in self.get_used_cells_by_id(14):
		self.set_cellv(cell, 14, randi() % 2, randi() % 2, randi() % 2)

	Event.connect("player_joined", self, "__player_joined")
	Event.connect("player_moved", self, "__player_moved")
	Event.connect("reload_game", self, "__reload_game")


func __get_player_team(username: String) -> int:
	for index in range(self.__teams.size()):
		if self.__teams[index].has(username):
			return index

	return -1


func __find_empty_neighbours(position: Vector2) -> Array:
	var neighbours: Array = []

	for offset in self.DIRECTION_OFFSETS:
		var new_position: Vector2 = position + offset
		if self.get_cellv(new_position) in self.__valid_fill_tiles:
			neighbours.append(new_position)

	return neighbours


func __move_player(team: int, direction: int) -> bool:
	var old_position = self.__team_positions[team]
	var new_position = old_position + self.DIRECTION_OFFSETS[direction]

	match self.get_cellv(new_position):
		6:
			self.__team_won(team)
			continue
		INVALID_CELL, 6:
			self.set_cellv(old_position, INVALID_CELL)
			self.set_cellv(new_position, self.TEAM_TILES[team])

			self.__team_positions[team] = new_position

			return true

	return false


func __player_joined(username: String) -> void:
	if self.__get_player_team(username) != -1:
		return

	var team = 0
	if self.__teams[0].size() > self.__teams[1].size():
		team = 1

	self.__teams[team].append(username)

	self.team_messages[team].text = self.MESSAGE_JOIN_FORMAT % username
	if self.__teams[0].size() == 1 && self.__teams[1].size() == 1:
		self.__start_game()


func __player_moved(username: String, direction: int) -> void:
	if !self.__playing:
		return

	var team = self.__get_player_team(username)
	if team == -1:
		return

	if self.__move_player(team, direction):
		var direction_name = self.DIRECTION_NAMES[direction]
		var message_params = [username, direction_name]
		if team == 1:
			message_params = [direction_name, username]

		self.team_messages[team].text = self.MESSAGE_MOVE_FORMAT % message_params


func __reload_game() -> void:
	if self.__playing:
		return

	SceneManager.reload_current()

func __start_game() -> void:
	for index in range(3, 0, -1):
		self.countdown.text = str(index)
		Event.emit_signal("game_starting", index)

		yield(self.get_tree().create_timer(1.0), "timeout")

	self.__playing = true

	self.countdown.text = "Go!"
	Event.emit_signal("game_starting", 0)

	yield(self.get_tree().create_timer(0.5), "timeout")

	self.countdown.text = ""



func __team_won(team: int) -> void:
	self.__playing = false

	yield(self.get_tree().create_timer(0.1), "timeout")
	self.__valid_fill_tiles.append(self.TEAM_TILES[(team + 1) % 2])
	var neighbours: Array = self.__find_empty_neighbours(Vector2(19.0, 10.0))

	while !neighbours.empty():
		yield(self.get_tree().create_timer(0.01), "timeout")

		var new_neighbours: Array = []

		for neighbour in neighbours:
			if self.get_cellv(neighbour) in self.__valid_fill_tiles:
				self.set_cellv(neighbour, self.TEAM_TILES[team])

			for new_neighbour in self.__find_empty_neighbours(neighbour):
				new_neighbours.append(new_neighbour)

		neighbours = new_neighbours
