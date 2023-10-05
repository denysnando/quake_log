# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MatchHistory do
  let(:kills) do
    [
      Kill.new(death_type: 'MOD_TRIGGER_HURT', killer_id: 1022, victim_id: 2),
      Kill.new(death_type: 'MOD_TRIGGER_HURT', killer_id: 1022, victim_id: 2),
      Kill.new(death_type: 'MOD_TRIGGER_HURT', killer_id: 1022, victim_id: 2),
      Kill.new(death_type: 'MOD_ROCKET_SPLASH', killer_id: 2, victim_id: 3),
      Kill.new(death_type: 'MOD_ROCKET_SPLASH', killer_id: 2, victim_id: 2),
      Kill.new(death_type: 'MOD_ROCKET_SPLASH', killer_id: 2, victim_id: 2),
      Kill.new(death_type: 'MOD_TRIGGER_HURT', killer_id: 1022, victim_id: 2),
      Kill.new(death_type: 'MOD_TRIGGER_HURT', killer_id: 1022, victim_id: 2),
      Kill.new(death_type: 'MOD_TRIGGER_HURT', killer_id: 1022, victim_id: 2),
      Kill.new(death_type: 'MOD_FALLING', killer_id: 1022, victim_id: 2),
      Kill.new(death_type: 'MOD_TRIGGER_HURT', killer_id: 1022, victim_id: 2)
    ]
  end

  let(:players) do
    [
      Player.new(id: 2, nickname: 'Isgalamido'),
      Player.new(id: 3, nickname: 'Mocinha')
    ]
  end

  let(:game_match) { instance_double('GameMatch', kills: kills, players: players) }
  let(:matches) { [game_match] }
  let(:match_history) { MatchHistory.new(matches: matches) }

  describe '#default' do
    it 'generates a default report' do
      allow(game_match).to receive(:calculate_total_kills).and_return(11)
      allow(game_match).to receive(:calculate_kills_by_player).and_return({ 'Isgalamido' => 9, 'Mocinha' => 2 })

      expected_report = {
        game_1: {
          total_kills: 11,
          players: ['Isgalamido', 'Mocinha'],
          kills: { 'Isgalamido' => 0, 'Mocinha' => 0 }
        }
      }

      expect(match_history.default).to eq(JSON.pretty_generate(expected_report))
    end
  end

  describe '#by_death_type' do
    it 'generates a report by death type' do
      allow(game_match).to receive(:calculate_total_kills).and_return(11)
      allow(game_match).to receive(:calculate_kills_by_death_type).and_return({ 'MOD_TRIGGER_HURT' => 8, 'MOD_ROCKET_SPLASH' => 3 })

      expected_report = {
        game_1: {
          total_kills: 11,
          players: ['Isgalamido', 'Mocinha'],
          kills_by_death_type: { 'MOD_TRIGGER_HURT' => 8, 'MOD_ROCKET_SPLASH' => 3 }
        }
      }

      expect(match_history.by_death_type).to eq(JSON.pretty_generate(expected_report))
    end
  end
end
