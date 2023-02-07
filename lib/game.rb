class Game

    attr_accessor :chosen_word
    attr_accessor :guess
    attr_accessor :lives

    def initialize()
        @chosen_word = random_word_select.split("")
        @guess = Array.new(chosen_word.length, "_")
        @lives = 8
        @guesses = []
    end

    def random_word_select()
        file = File.readlines('google-10000-english-no-swears.txt')
    
        file.each{|w|
            w.gsub!("\n","")
        }
        word = file[rand(file.length)]
    
        while word.length < 5 || word.length > 12 do
            word = file[rand(file.length)]
        end
    
        word
    end
    
    def draw_word(word)
        word.each{|c|
            print(c+" ")
        }
        puts "\n"
    end
    
    def guess_is_ok(l)
        return l.length == 1 && !@guesses.include?(l) || l === "save"
    end
    
    def make_guess()
            puts "Type 'save' to save game!\nOR\nGuess a letter that you have not guessed yet!\nLives left: #{lives}\nWords to guess:"
            draw_word(@guess)
            print("\nYour guesses so far: ")
            pp @guesses
            puts "\n"
            print("Your input: ")
            letter = gets.chomp
            letter.downcase!
            while !guess_is_ok(letter) do
                puts "Invalid Input!\nTry again!\nLetter: "
                letter = gets.chomp
                letter.downcase!
            end
            if letter === "save"
                return letter
            end
            @guesses.append(letter)
            if @chosen_word.include?(letter)
                @chosen_word.each_with_index{|l,index|
                    if l == letter
                        @guess[index] = letter
                    end
                }
            else
                puts "The word does not include the letter #{letter}"
                @lives-= 1
            end
        draw_word(@guess)
        puts "______________________"
        system("clear")
        return letter
    end
    
    def is_over()
        if @lives == 0 || !@guess.include?("_")
            if @lives > 0
                puts "Congratulations, you have correctly guessed the word!"
            else
                puts "You lost! The word was: #{@chosen_word.join("")}"
            end
            true
        else
            false
        end
    end
    
end