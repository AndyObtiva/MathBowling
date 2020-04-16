# Math Bowling 0.9.2 Beta 3

![Math Bowling Screenshot](https://raw.githubusercontent.com/AndyObtiva/MathBowling/master/images/Math-Bowling-Screenshot.png)

Math Bowling is an elementary level educational math game.

Developed with [Glimmer](https://github.com/AndyObtiva/Glimmer) and [JRuby](https://www.jruby.org/).

# Game Rules

- On a player's turn, a math question must be answered to initiate a bowling roll
- A player must answer math questions until filling a frame just like bowling.
- Players must fill all 10 frames just like bowling to finish the game.
- A player has 20 seconds to answer a question
- If a player does not answer on time, whatever was entered is taken as the answer. If nothing was entered, then the answer is assumed to be 0
- If an answer is correct, the player gets the equivalent of knocking all remaining pins (strike for 10, spare for less than 10)
- If an answer is within the number of remaining pins from the correct answer, then it is considered close. The player gets the equivalent of knocked pins for that answer (e.g. answering 3 or 5 to 2 + 2 gets all remaining pins minus 1). This makes answering the next question more challenging just like in bowling
- If an answer is farther from the correct answer than number of remaining pins, then 0 is awarded.
- The player with the higher score at the end wins.
- If both players have the same score at the end, it is a tie.
- Players are distinguished by position and color.
- The game may be played with one player only, in which case it is always that player's turn on every bowling roll (question answered).

# Use Cases

1. Start 1 Player Game
1. Start 2 Player Game
1. Start 3 Player Game
1. Start 4 Player Game
1. Exit Game
1. Answer Question
1. Restart Game
1. Change Player Count

# User Stories / Release Plan

[DONE] 0.1.0 Alpha 1 Release:

1. [DONE] Start game
1. [DONE] Bowl with simple math question and fixed time limit

[DONE] 0.2.0 Alpha 2 Release:

1. [DONE] Start two player game
1. [DONE] Bowl the player whose turn it is to bowl
1. [DONE] Style with colors and fonts
1. [DONE] Layout content nicely
1. [DONE] Play sound effects for bowling with different sounds for strike/spare, partial knock, and miss

[DONE] 0.9.0 Beta 1 Release:

1. [DONE] Display a splash image when launching game
1. [DONE] Display image for getting a correct, wrong, or close answer.
1. [DONE] Make buttons bigger

[DONE] 0.9.1 Beta 2 Release:

1. [DONE] Center windows
1. [DONE] Add question answering time limit

[DONE] 0.9.2 Beta 3 Release ([download](https://1drv.ms/u/s!As1vHoYfypJ0gZcDaUq46wxUD1eSoA?e=2ccsHF)):

1. [DONE] Replace image for getting a correct, wrong, or close answer with a video instead.
1. [DONE] Support up to 4 players
1. [DONE] Package for MacOS

[DONE] 0.9.3 Beta 4 Release ([download](https://1drv.ms/u/s!As1vHoYfypJ0gZcGiiaAgr2ywcNisw?e=z1dBIm)):

1. [DONE] Speed up startup time

1.0.0 Final Release:

1. [DONE] Adjust Time To Answer from 20 to 30 seconds
1. [DONE] Highlight current player question with player color
1. [DONE] End of Game Winner Announcement
1. Input Validation (positive integers only and limited to 3 digits)
1. Menu Options
1. Icon/Background for MacOS Package

1.1.0 Release:

1. Package for Windows

1.2.0 Release:

1. Package for Linux

2.0.0 Release:

1. Multiple difficulties
1. Players can choose unique player color to distinguish themselves
1. Players may enter name

# License

Copyright (c) 2019-2020 Andy Maleh. See LICENSE.txt for further details.
