class_name LocalInput extends Node

const DIRECTION_KEYS = [
	[KEY_W, KEY_S, KEY_A, KEY_D],
	[KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]
]

var __players_joined = [false, false]


func _ready() -> void:
	for player in range(2):
		for direction in range(4):
			var event = InputEventKey.new()
			event.scancode = self.DIRECTION_KEYS[player][direction]
			var action_name = "player_%d_%s" % [player, direction]
			InputMap.add_action(action_name)
			InputMap.action_add_event(action_name, event)


func _process(delta: float) -> void:
	for player in range(2):
		for direction in range(4):
			var action_name = "player_%d_%s" % [player, direction]
			if Input.is_action_just_pressed(action_name):
				var username = "Player %d" % (player + 1)

				if !self.__players_joined[player]:
					self.__players_joined[player] = true
					Event.emit_signal("player_joined", username)
					break

				Event.emit_signal("player_moved", username, direction)
