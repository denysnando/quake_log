module Repl
  class Main < Base
    private

    def title
      'Select an option:'
    end

    def options
      {
        '1': { label: 'Generate list kill by players', method: :kill_by_players },
        '2': { label: 'Generate list grouped by death type', method: :by_death_type }
      }
    end

    def parsed_matches
      log_file = File.open('spec/fixtures/example.log')
      log_parser = LogParser.new(file: log_file)
      log_parser.parser
    end

    def kill_by_players
      puts puts JSON.parse(json_pretty_by_player)
    end

    def by_death_type
      puts JSON.parse(json_pretty_by_death_type)
    end

    def json_pretty_by_death_type
      match_history = MatchHistory.new(matches: parsed_matches)
      JSON.pretty_generate(match_history.by_death_type)
    end

    def json_pretty_by_player
      match_history = MatchHistory.new(matches: parsed_matches)
      JSON.pretty_generate(match_history.default)
    end
  end
end
