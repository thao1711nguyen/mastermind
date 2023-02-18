
#function game
    #initialize a count variable equals 0
    #WHILE count is less than or equal to 12
        #Ask the user's guess: 4 colors
        #Initialize a result-array: 
            #1 for right position and right color
            #0 for right color but not position
            #none for not right color and position
        #IF result-array consists 4 red
            #player won
            #break out of loop
        #ELSIF count equals to 12 and result-array does not equal 4 red
            #player lost 
            #display the code
        #ELSE 
            #display hints

def codeMaker
    codes = [1,2,3,4,5,6]
    codes += codes
    codes.sample(4)
end
def instruct
    puts "From 1 to 6, What is your choice? "
end
def gameForHuman
    count = 0
    codes = codeMaker
    
    while count <= 12
        instruct
        userGuess = gets.chomp.gsub(/\s+/,'').split('').map(&:to_i)
        match_result = match(codes, userGuess)
        winCondition = match_result.length == 4 && match_result.all?(1) 
        if winCondition
            puts 'You win! Congratulation!'
            return
        elsif count == 12 && !winCondition
            puts 'Sorry, you lose'
            print 'Here is the secret code: '  
            puts codes.join('  ')
        else 
            print 'hints: '
            puts match_result.shuffle.join('  ')
            puts "1: right color & right position\n0: right color but wrong position"
        end
        count += 1
    end
end
def match(codes,userGuess)
    codes = transform(codes) #transform into a hash
    userGuess = transform(userGuess)
    
    result = []
    match_test = lambda { |standard, toBeCompared, result| standard.each do |position|
                            if toBeCompared.include?(position) 
                                result.push(1)
                            else 
                                result.push(0)
                            end
                        end}
    userGuess.each do |color, positions| 
        if !codes[color].empty?
            if positions.length < codes[color].length
                match_test.call(positions, codes[color], result)
            else  
                match_test.call(codes[color], positions, result)
            end
        end
    end
    result
end
def transform(colors)
    colorsAndPositions =Hash.new { |hash, key| hash[key] = [] }
    colors.each_with_index do |color, position|
        colorsAndPositions[color].push(position)
    end
    colorsAndPositions
end

def game
    puts "You wanna be codemaker (m) or codebreaker (b)?"
    choice = gets.chomp 
    if choice == 'm'
        gameForComputer
    else 
        gameForHuman
    end
end
def gameForComputer
    instruct
    code = gets.chomp.split('').map(&:to_i)
    count = 0 
    allCodes = generateCodes #Step1: generate 6**4 codewords
    while count <=10
        count += 1
        print "My guess is: " 
        if count == 1 
            guess = [1,1,2,2] 
        end
        puts guess.join('  ')
        puts 'Please give me a hint: '
        #hints = gets.chomp.gsub(/\s+/,'').split('').map(&:to_i)
        hints = match(code,guess)
        puts hints.join('  ')
        winCondition = hints.count(1) == 4
        if winCondition
            puts "round: #{count}"
            puts "The computer won!"
            break
        elsif !winCondition && count == 10
            print "The computer lost! This is your code: " 
            p code
        else
            allCodes.delete(guess) #remove last guess from the possible guesses
            if count == 1 
                potentialCodes = allCodes.dup #shallo copy allCodes to potentialCodes
            end
            potentialCodes.delete(guess)
            #compare potentialCodes with last guess, if it gives the same hint, keep it
            potentialCodes = generatePotentialCodes(potentialCodes,hints,guess)

            guess = generateGuess(potentialCodes,allCodes) 
            puts "This is round #{count}"
            print "potentialCodes.length is: "
            puts potentialCodes.length
            puts potentialCodes.include?(code)
        end
    end
    
end
def generateCodes
    allCodes = []
    [1,2,3,4,5,6].repeated_permutation(4) do |permutation|
        allCodes.push(permutation)
    end
    allCodes
end
def generatePotentialCodes(potentialCodes, hints, guess)
    potentialCodes.each do |code|
       assummedResult = match(code,guess) 
       acceptCondition = assummedResult.count(1) == hints.count(1) \
                        && assummedResult.count(0) == hints.count(0)
        if !acceptCondition
            potentialCodes.delete(code)
        end
    end
    potentialCodes
end
def generateGuess(potentialCodes, allCodes)
    #binding.pry
    maxScores = {}
    allCodes.each do |guess|
        scores_by_guess = Hash.new(0)
        potentialCodes.each do |potentialCode| #assume each code in potentialCodes is the secret code
                                                #compare secret code with each guess in allCodes -> score
                                                #keep track of the number of score for each guess
            assummedResult = match(potentialCode,guess)
            numberOf1 = assummedResult.count(1)
            numberOf0 = assummedResult.count(0) 
            scores_by_guess[[numberOf1,numberOf0]] += 1
        end 
        maxScores[guess] = scores_by_guess.values.max #select the highest score of each guess and push it to the array
    end
    minMax = maxScores.values.min
    finalGuess = nil
    if maxScores.values.count(minMax) > 1 #check whether there are multiple minmax values
        minMaxScores = maxScores.select {|code, score| score == minMax}  #if so, pull them out
        guesses = minMaxScores.keys.sort #sort by numerical order
        guesses.each do |guess| #choose the one that in potentialCodes or the first one
            if potentialCodes.include?(guess)
                finalGuess = guess
                break
            else 
                finalGuess = guesses[0]
            end
        end
    else  
        finalGuess = maxScores.key(minMax)
    end
    finalGuess
end
game

