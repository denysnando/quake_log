# frozen_string_literal: true

class LogParser
  attr_accessor :matches

  def initialize(file:)
    @file = file
    @matches = []
  end

  def parser
    game_match = nil
    @file.each_line do |line|
      if line.include? 'InitGame:'
        game_match = new_game_match
        matches << game_match
      end

      instance_player(line:, game_match:) if line.include?('ClientUserinfoChanged:')
      create_kill(line:, game_match:) if line.include?('Kill:')
    end

    matches
  end

  private

  def new_game_match
    GameMatch.new
  end

  def create_kill(line:, game_match:)
    parts = line.split(' ')
    if parts.size >= 7
      killer_id, victim_id, description = parts[2], parts[3], parts[5..].join(' ')
      death_type = description.split(' ')[-1]
      game_match.create_kill(killer_id: killer_id, victim_id: victim_id, death_type: death_type)
    else
      puts "Invalid Kill line: #{line}"
    end
  end

  def instance_player(line:, game_match:)
    parts = line.split(' ')

    if parts.size >= 4
      player_id, connection_info = parts[2], parts[3]
      nickname = connection_info.split('\\')[1]
      game_match.find_player(id: player_id.to_i, nickname: nickname)
    else
      puts "Invalid ClientUserinfoChanged line: #{line}"
    end
  end
end
