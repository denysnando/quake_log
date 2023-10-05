# frozen_string_literal: true

require 'json'

class MatchHistory
  def initialize(matches:)
    @matches = matches
  end

  def default
    generate_report { |game_match| basic_report(game_match) }
  end

  def by_death_type
    generate_report { |game_match| death_type_report(game_match) }
  end

  private

  def generate_report(&block)
    data = {}

    @matches.each_with_index do |game_match, index|
      data["game_#{index + 1}"] = yield(game_match)
    end

    JSON.pretty_generate(data)
  end

  def basic_report(game_match)
    {
      total_kills: game_match.calculate_total_kills,
      players: sorted_player_nicknames(game_match),
      kills: generate_kills(players: game_match.players, kills: game_match.calculate_kills_by_player)
    }
  end

  def death_type_report(game_match)
    {
      total_kills: game_match.calculate_total_kills,
      players: sorted_player_nicknames(game_match),
      kills_by_death_type: sort_kills_by_death_type(game_match.calculate_kills_by_death_type)
    }
  end

  def sorted_player_nicknames(game_match)
    game_match.players.map(&:nickname).sort
  end

  def generate_kills(players:, kills:)
    data = {}
    players.each { |player| data[player.nickname] = kills[player.id] || 0 }
    data.sort_by { |_key, value| -value }.to_h
  end

  def sort_kills_by_death_type(kills_by_death_type)
    kills_by_death_type.sort_by { |_key, value| -value }.to_h
  end
end
