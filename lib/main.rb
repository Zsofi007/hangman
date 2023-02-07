require 'csv'

require_relative 'game'

require 'yaml'

def save_game(current_game)
  filename = prompt_name
  return false unless filename
  dump = YAML.dump(current_game)
  File.open(File.join(Dir.pwd, "/saved/#{filename}.yaml"), 'w') { |file| file.write dump }
end

def prompt_name
  begin
    filenames = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))]}
    puts "Enter name for saved game"
    filename = gets.chomp
    raise "#{filename} already exists." if filenames.include?(filename)
    filename
  rescue StandardError => e
    puts "#{e} Are you sure you want to rewrite the file? (Yes/No)".red
    answer = gets[0].downcase
    until answer == 'y' || answer == 'n'
      puts "Invalid input. #{e} Are you sure you want to rewrite the file? (Yes/No)".red
      answer = gets[0].downcase
    end
    answer == 'y' ? filename : nil
  end
end

def load_game
  filename = choose_game
  saved = File.open(File.join(Dir.pwd, filename), 'r')
  loaded_game = YAML.unsafe_load(saved)
  saved.close
  loaded_game
end

def choose_game
  begin
    puts "Here are the current saved games. Please choose which you'd like to load."
    filenames = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
    puts filenames
    print("Chosen file: ")
    filename = gets.chomp
    raise "#{filename} does not exist.".red unless filenames.include?(filename)
    puts "#{filename} loaded..."
    puts
    "/saved/#{filename}.yaml"
  rescue StandardError => e
    puts e
    retry
  end
end

def start
    Dir.mkdir('saved') unless Dir.exist?('saved')
    puts "Hangman. Would you like to: 1) Start a new game"
    puts "                            2) Load a game"
    puts "                            3) Quit game"


    user_choice = gets.chomp
    puts
    until ['1', '2','3'].include?(user_choice)
    puts "Invalid input. Please enter 1 or 2!"
    user_choice = gets.chomp
    end
    
    if user_choice == '1'
        game = Game.new
    elsif user_choice == '2'
        game = load_game
    else
        exit(0)
    end
    start_with_command(game)
end

def start_with_command(game)
    until game.is_over
        if game.make_guess == 'save'
            if save_game(game)
            puts "Your game has been saved. Thanks for playing!"
            break
            end
        end
    end
    start
end

start


