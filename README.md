# Math Bowling 1.0.1

![Math Bowling Screenshot](https://raw.githubusercontent.com/AndyObtiva/MathBowling/master/images/Math-Bowling-Screenshot.png)

<span style="font-size: 1.9em; position: relative; top: 5px">[<img alt="Math Bowling Logo" src="images/math-bowling-logo.png" width="40" />Download Math Bowling 1.0.1 for Mac]()</span>

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

[DONE] 1.0.0 Release ([download](https://1drv.ms/u/s!As1vHoYfypJ0gZdcxapMZPTQIWKRYA?e=J4sWjN)):

1. [DONE] Adjust Time To Answer from 20 to 30 seconds
1. [DONE] Highlight current player question with player color
1. [DONE] End of Game Winner Announcement
1. [DONE] Input Validation (positive integers only and limited to 3 digits)
1. [DONE] Menu Options
1. [DONE] Icon/Background for MacOS Package

[DONE] 1.0.1 Release ([download]()):
1. [DONE] Fix issue with game font not showing up on some older Macs
1. [DONE] Fix video scrollbar issue on some older Macs
1. [DONE] Improve wording of buttons
1. [DONE] Improve difficulty of questions

2.0.0 Release:

1. Fix odd layout issues on some older Macs
1. [DONE] Fix issue with game font not showing up on some older Macs
1. Fix video scrollbar issue on some older Macs
1. Fix clarity for which player's turn it is
1. Multiple difficulties (Easy, Medium, Hard) with more difficult questions and shorter answer time
1. Players can choose unique player color to distinguish themselves
1. Players may enter name
1. Spare shot video
1. Multiple videos for each scoring type

2.1.0 Release:

1. Implement correct layout on Windows
1. Package for Windows

2.2.0 Release:

1. Package for Linux

# License

Copyright (c) 2019-2020 Andy Maleh. See LICENSE.txt for further details.
