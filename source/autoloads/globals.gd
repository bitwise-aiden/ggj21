extends Node

enum GameModes { LOCAL = 0, STREAMER, EXTERNAL, MAX }


# Time globals

# Current rate of time passing.
#	1.0 is default
#	< 1.0 is slowed down
#	> 1.0 is speed up
var time_modifier = 1.0

var played_intro = true


# Instance globals
var game_mode: int = GameModes.LOCAL
var twitch_input_instance = null
