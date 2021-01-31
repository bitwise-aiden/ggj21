# ggj ideas:
# - theme: Lost and found
# - diversifiers:
#     - accessibility:
#         - Spinal Tap (slider for all audio types)
#     - art:
#         - Are we ASCIIng too much? (ascii graphics)
#         - Get to the point (pointillist style, shaders?)
#     - code:
#         - RNG (but for something typically static)
#     - design:
#         - Moving the goalposts (objective changes each time it's played)
#         - How many of you are in there? (twitch chat?)
#     - meta:
#         - On the safe side (100km team)
#         - A-Party (game for video call)

# Chat based team maze escape game
#	Each player joins the game and is assigned to a team
#	Once the game starts they can input "up", "down", "left", "right" to move the character
#		fuzzy search for terms "pu" "dwon"
#		input.sort() <union> "down" && input.size() ~= "down".size()
#	First team to escape the maze wins

# - [x] Add text at top of screen to show who pressed what for both teams
# - [ ] Add some kind of screen shake / movement to indicate successful movements by one of the teams
# - [ ] STRETCH: Add a randomizer to change the maze for each run
# - [ ] Add ability for bot to set `/slow <user_input_number` for chat at start of game, returning to normal at end of game. (May need to figure out current slow level and return to that)
# - [x] Add bot outputting game starting in chat with some basic info
# - [x] Add screen effects for game starting, countdown, etc. (Will be delayed, but eh...)
# - [ ] Add note on screen when in streamer mode that there will be a delay
# - [x] Add win condition showing the winning team (once the player has reached the win area, they scale up and have particle effects from behind them to signal they won, then a rematch + menu popup modal)
# - [ ] Add a mode selection to set what the input it
# - [x] Mode streamer:
#   - [x] Add information screen about it and what it means
#   - [x] Add config settings that will let the user input their stream info (password hidden)
#   - [x] Add option to save settings for next time
#   - [x] Add loading settings with option to remove on subsequent loads
# - [x] Mode external:
#   - [x] Add server to accept requests from outside integrations to join and make moves as players
#   - [x] Create meet interface using Selenium or something similar to record messages from chat
# - [x] Mode 1v1 local:
#   - [x] Add ability for two players to use wasd and arrows to compete
# - [ ] Add title screen that has name and a scrolling select with information about the game modes and a little picture
# - [ ] Add settings screen to change volume, etc
# - [ ] Add mid game menu screen to access settings, restart, or go to menu

