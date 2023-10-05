module Repl
  class Base
    def initialize
      clear_screen
    end

    def run
      loop do
        puts title unless title.empty?
        puts options_to_a
        command = gets.chomp.strip

        exit if command.match?(/exit/i)
        raise NotImplementedError, 'Invalid option' unless options.key?(command.to_sym)
        send(options[command.to_sym][:method])

        puts "----------------- \n"
      end
    end

    private

    def title
      ''
    end

    def clear_screen
      system('clear') || system('cls')
    end

    def options
      raise NotImplementedError, 'You must implement the "options" method in your subclass.'
    end

    def options_to_a
      options.map { |key, value| "#{key}: #{value[:label]}" }
    end

    def run_command(command, opts = { clear: true })
      clear_screen if opts[:clear]

      puts command
      gets.chomp.strip
    end
  end
end
