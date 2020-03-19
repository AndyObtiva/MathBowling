# Math Bowling 0.2.0 Alpha

![Math Bowling Screenshot](https://raw.githubusercontent.com/AndyObtiva/MathBowling/master/images/Math-Bowling-Screenshot.png)

Math Bowling is an elementary level educational math game.

Developed with [Glimmer](https://github.com/AndyObtiva/Glimmer) and [JRuby](https://www.jruby.org/).

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
1. [DONE] Layout content nicely
1. [DONE] Play sound effects for bowling with different sounds for strike/spare, partial knock, and miss

0.9.0 Beta Release:

1. Display a splash image when launching game
1. [DONE] Display image for getting a correct, wrong, or close answer.
1. [DONE] Make buttons bigger

0.9.1 Beta Release:

1. Add question answering time limit
1. Center windows

0.9.2 Beta Release:

1. Replace image for getting a correct, wrong, or close answer with a video instead.


# License

Copyright (c) 2019-2020 Andy Maleh. See LICENSE.txt for further details.
