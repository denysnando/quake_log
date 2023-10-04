# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser do
  let(:example_log_file) { File.open('spec/fixtures/example.log') }
  let(:log_parser) { described_class.new(file: example_log_file) }

  describe '#parser' do
    it 'parses the log file and extracts game matches' do
      matches = log_parser.parser
      expect(matches).to be_an(Array)
      expect(matches).not_to be_empty
      expect(matches.all? { |match| match.is_a?(GameMatch) }).to be true
    end

    it 'parses and extracts kills from the log file' do
      matches = log_parser.parser
      expect(matches.all? { |match| match.kills.all? { |kill| kill.is_a?(Kill) } }).to be true
    end

    it 'parses and extracts players from the log file' do
      matches = log_parser.parser
      expect(matches.all? { |match| match.players.all? { |player| player.is_a?(Player) } }).to be true
    end
  end

  describe '#create_kill' do
    it 'creates a Kill object from a valid kill line' do
      line = "22:06 Kill: 2 3 7: Isgalamido killed Mocinha by MOD_ROCKET_SPLASH"
      game_match = instance_double(GameMatch)
      expect(game_match).to receive(:create_kill).with(killer_id: '2', victim_id: '3', death_type: 'MOD_ROCKET_SPLASH')
      log_parser.send(:create_kill, line: line, game_match: game_match)
    end

    it 'does not create a Kill object for an invalid kill line' do
      line = "Invalid Kill line"
      game_match = instance_double(GameMatch)
      expect { log_parser.send(:create_kill, line: line, game_match: game_match) }.to output(/Invalid Kill line/).to_stdout
    end
  end

  describe '#instance_player' do
    it 'instantiates a player for a valid ClientUserinfoChanged line' do
      line = "20:37 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0"
      game_match = instance_double(GameMatch)
      expect(game_match).to receive(:find_player).with(id: 2, nickname: 'Isgalamido')
      log_parser.send(:instance_player, line: line, game_match: game_match)
    end

    it 'does not instantiate a player for an invalid ClientUserinfoChanged line' do
      line = "Invalid ClientUserinfoChanged line"
      game_match = instance_double(GameMatch)
      expect { log_parser.send(:instance_player, line: line, game_match: game_match) }.to output(/Invalid ClientUserinfoChanged line/).to_stdout
    end
  end
end
