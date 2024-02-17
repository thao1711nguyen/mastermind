# mastermind
This is part of the course Ruby of The Odin Project. 
Check it out at the link: https://www.theodinproject.com/lessons/ruby-mastermind

This is a simple mastermind game that can be played on the console. 
Player can choose to break the code or be the code maker. 
If player choose to be code breaker, they have 12 guesses. 
The code is a combination of 4 numbers, each has to be from 1 to 6. 

I only used Ruby for this project. 
I also implement an algorithm (developed by Donald Knuth) for the computer to always break the code in 5 guesses or less. Detail of the algorithm is described below: 

    - Create the set S of 1296 possible codes (1111, 1112 ... 6665, 6666).
    - Start with initial guess 1122 (Knuth gives examples showing that other first guesses such as 1123, 1234 do not win in five tries on every code).
    - Play the guess to get a response of colored and white pegs. 
        + If the response is four colored pegs, the game is won, the algorithm terminates.
        + Otherwise, remove from S any code that would not give the same response if the current guess were the code.
    - Apply minimax technique to find a next guess as follows:
        + For each possible guess, that is, any unused code of the 1296 not just those in S, calculate how many possibilities in S would be eliminated for each possible colored/white peg score. The score of a guess is the minimum number of possibilities it might eliminate from S.
        + From the set of guesses with the minimum (max) score, select one as the next guess, choosing a member of S whenever possible.

        + Knuth follows the convention of choosing the guess with the least numeric value e.g. 2345 is lower than 3456. Knuth also gives an example showing that in some cases no member of S will be among the highest scoring guesses and thus the guess cannot win on the next turn, yet will be necessary to assure a win in five.

