# frozen_string_literal: true

class GameMatch
  attr_accessor :players, :kills

  def initialize
    @players = []
    @kills = []
  end

  def find_player(id:, nickname:)
    player = find_player_by_id(id)

    if player
      player.nickname = nickname
    else
      player = create_player(id, nickname)
    end

    player
  end

  def create_kill(killer_id:, victim_id:, death_type:)
    kills << create_kill_instance(killer_id, victim_id, death_type)
  end

  def calculate_total_kills
    player_kills.values.sum + word_dead.values.sum
  end

  def calculate_kills_by_player
    player_kills.merge(word_dead) do |_key, value1, value2|
      value1 - value2
    end
  end

  def calculate_kills_by_death_type
    @kills.reject(&:suicide?).group_by(&:death_type).transform_values(&:count)
  end

  private

  def find_player_by_id(id)
    players.find { |player| player.id == id }
  end

  def create_player(id, nickname)
    player = Player.new(id: id.to_i, nickname: nickname)
    players << player
    player
  end

  def create_kill_instance(killer_id, victim_id, death_type)
    Kill.new(
      killer_id: killer_id.to_i,
      victim_id: victim_id.to_i,
      death_type: death_type
    )
  end

  def word_dead
    @kills.select(&:world?).group_by(&:victim_id).transform_values(&:count)
  end

  def player_kills
    @kills.reject(&:suicide?).reject(&:world?).group_by(&:killer_id).transform_values(&:count)
  end
end
