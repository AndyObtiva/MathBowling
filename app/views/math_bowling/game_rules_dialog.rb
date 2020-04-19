class MathBowling
  class GameRulesDialog
    include Glimmer::UI::CustomShell

    body {
      shell(:dialog_trim, :application_modal) {
        text 'Game Rules'
        minimum_size 1000, 750
        browser {
          text <<~MULTI_LINE
          <style>
          body {
            background-color: beige;
            font-family: "Abadi MT Condensed Extra Bold";
            color: rgb(128, 0, 0);
            padding: 20px 40px;
            background: radial-gradient(circle, rgba(236,205,136,1) 70%, rgba(255,255,192,1) 100%);
          }
          h1, h2 {
            text-align: center;
          }
          h1 {
            font-size: 60px;
            padding-bottom: 0;
            margin-bottom; 0;
          }
          h2 {
            margin: 0;
            padding: 0;
            font-size: 40px;
            margin-top: -40px;
          }
          ol {
            text-align: 'justify';
            font-size: 1.3em;
            color: black;
          }
          li {
            margin-bottom: 10px
          }
          </style>
          <h1>Math Bowling</h1>
          <h2>Game Rules</h2>
          <ol>
            <li>On a player's turn, a math question must be answered to initiate a bowling roll</li>
            <li>A player must answer math questions until filling a frame just like bowling.</li>
            <li>Players must fill all 10 frames just like bowling to finish the game.</li>
            <li>A player has 20 seconds to answer a question</li>
            <li>If a player does not answer on time, whatever was entered is taken as the answer. If nothing was entered, then the answer is assumed to be 0</li>
            <li>If an answer is correct, the player gets the equivalent of knocking all remaining pins (strike for 10, spare for less than 10)</li>
            <li>If an answer is within the number of remaining pins from the correct answer, then it is considered close. The player gets the equivalent of knocked pins for that answer (e.g. answering 3 or 5 to 2 + 2 gets all remaining pins minus 1). This makes answering the next question more challenging just like in bowling</li>
            <li>If an answer is farther from the correct answer than number of remaining pins, then 0 is awarded.</li>
            <li>The player with the higher score at the end wins.</li>
            <li>If both players have the same score at the end, it is a tie.</li>
            <li>Players are distinguished by position and color.</li>
            <li>The game may be played with one player only, in which case it is always that player's turn on every bowling roll (question answered).</li>
          </ol>
          MULTI_LINE
        }
      }
    }
  end
end
