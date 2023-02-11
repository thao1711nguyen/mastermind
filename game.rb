#make a function generate random code of 4 colors from 6 colors: 
    #1: red -> r
    #2: blue -> b
    #3: green -> g
    #4: yellow -> y
    #5: white -> w
    #6: purple -> p
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
    codes = ['r','b','g','y','w','p']
    codes += codes
    codes.sample(4)
end
def instruct
    colors = ['red','blue','green','yellow','white','purple']
    colors.each do |color|
        puts "#{color.chr} stands for #{color}"
    end
    puts "What is your guess? "
end
def game
    count = 0
    codes = codeMaker
    hash_codes = transform(codes)
    while count <= 12
        instruct
        userGuess = gets.chomp.split(',')
        userGuess = transform(userGuess)
        match_result = match(hash_codes, userGuess)
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
    result = []
    match_test = lambda { |standard, toBeCompared, result| standard.each_with_index do |position|
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

game
