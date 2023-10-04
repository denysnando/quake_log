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
end
