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
end
