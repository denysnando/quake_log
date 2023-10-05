# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GameMatch do
  let(:game_match) { GameMatch.new }

  describe '#find_player' do
    it 'finds an existing player and updates the nickname' do
      player = Player.new(id: 1, nickname: 'Dono da bola')
      game_match.players << player

      updated_player = game_match.find_player(id: 1, nickname: 'Isgalamido')

      expect(updated_player).to eq(player)
      expect(player.nickname).to eq('Isgalamido')
    end

    it 'creates a new player if not found' do
      player = game_match.find_player(id: 2, nickname: 'Zeh')

      expect(player.id).to eq(2)
      expect(player.nickname).to eq('Zeh')
      expect(game_match.players).to include(player)
    end
  end

  describe '#create_kill' do
    it 'creates a new kill and adds it to the kills array' do
      game_match.create_kill(killer_id: 1, victim_id: 2, death_type: 'MOD_SHOTGUN')

      expect(game_match.kills.length).to eq(1)
      expect(game_match.kills.first).to be_a(Kill)
    end
  end

  describe '#calculate_total_kills' do
    it 'calculates the total number of kills in the game' do
      game_match.create_kill(killer_id: 1, victim_id: 2, death_type: 'MOD_SHOTGUN')
      game_match.create_kill(killer_id: 3, victim_id: 2, death_type: 'MOD_RAILGUN')

      expect(game_match.calculate_total_kills).to eq(2)
    end
  end

  describe '#calculate_kills_by_player' do
    it 'calculates kills by player' do
      game_match.create_kill(killer_id: 1, victim_id: 2, death_type: 'MOD_SHOTGUN')
      game_match.create_kill(killer_id: 1, victim_id: 3, death_type: 'MOD_SHOTGUN')
      game_match.create_kill(killer_id: 2, victim_id: 1, death_type: 'MOD_ROCKET')
      game_match.create_kill(killer_id: 3, victim_id: 1, death_type: 'MOD_RAILGUN')

      expected_result = { 1 => 2, 2 => 1, 3 => 1 }
      expect(game_match.calculate_kills_by_player).to eq(expected_result)
    end
  end

  describe '#calculate_kills_by_death_type' do
    it 'calculates kills by death type' do
      game_match.create_kill(killer_id: 1, victim_id: 2, death_type: 'MOD_SHOTGUN')
      game_match.create_kill(killer_id: 3, victim_id: 2, death_type: 'MOD_RAILGUN')
      game_match.create_kill(killer_id: 2, victim_id: 1, death_type: 'MOD_ROCKET')
      game_match.create_kill(killer_id: 3, victim_id: 1, death_type: 'MOD_RAILGUN')

      expected_result = { 'MOD_SHOTGUN' => 1, 'MOD_RAILGUN' => 2, 'MOD_ROCKET' => 1 }
      expect(game_match.calculate_kills_by_death_type).to eq(expected_result)
    end
  end
end
