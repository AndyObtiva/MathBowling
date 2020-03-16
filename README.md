# Math Bowling

Bowling game that tests math skills. Built with Glimmer and Ruby (JRuby).

This will be a single player game. In the future, it can become a multiplayer game.

# Use Cases

UC1: Start Game

1. User chooses to start a new game
1. System starts a new game with all frames empty, erasing previous game stats if any

UC2: Bowl

1. User initiates bowling action
1. System asks a math question and shows a time limit
1. User answers or misses question
1. System scores frame based on user response to question
1. System determines whether user can bowl again or game is over, displaying status accordingly (win or lose)

UC3: Exit Game

1. User chooses to exit game
2. System exits

# Stories / Release Plan

[DONE] 0.1.0 Alpha Release:

1. [DONE] Start game
1. [DONE] Bowl with simple math question and fixed time limit

[DONE] 0.2.0 Alpha Release:

1. [DONE] Start two player game
1. [DONE] Bowl the player whose turn it is to bowl
1. [DONE] Style with colors and fonts
1. Layout content nicely
1. [DONE] Play sound effects for bowling with different sounds for strike/spare, partial knock, and miss

0.3.0 Alpha Release:

1. Display static image when starting a game
1. Display static image when bowling
1. Temporarily display static image for getting a strike, a spare, a partial knock, or a miss.
1. Show number of pins knocked out of total pins remaining after temporarily displaying static image for getting a strike, a spare, a partial knock, or a miss.

0.9.0 Beta Release:

1. Add question answering time limit
1. Display video when bowling
1. Replace temporary static image for getting a strike, a spare, a partial knock, or a miss with a video instead.

# License

Copyright (c) 2019-2020 Andy Maleh. See LICENSE.txt for further details.
