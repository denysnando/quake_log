# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kill do
  let(:valid_kill) { described_class.new(killer_id: 1001, victim_id: 1002, death_type: 'MOD_RAILGUN') }
  let(:world_kill) { described_class.new(killer_id: Kill::KILLER_WORLD_ID, victim_id: 1002, death_type: 'MOD_GRENADE') }
  let(:suicide_kill) { described_class.new(killer_id: 1003, victim_id: 1003, death_type: 'MOD_TRIGGER_HURT') }

  describe '#initialize' do
    context 'with valid input' do
      it 'creates a Kill object' do
        expect(valid_kill).to be_an_instance_of(described_class)
      end
    end

    context 'with invalid input' do
      it 'raises an ArgumentError for non-integer killer_id' do
        expect do
          described_class.new(killer_id: 'invalid', victim_id: 1002, death_type: 'MOD_RAILGUN')
        end.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError for non-integer victim_id' do
        expect do
          described_class.new(killer_id: 1001, victim_id: 'invalid', death_type: 'MOD_RAILGUN')
        end.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError for empty death_type' do
        expect { described_class.new(killer_id: 1001, victim_id: 1002, death_type: '') }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#world?' do
    it 'returns true for the world killer_id' do
      expect(world_kill.world?).to be true
    end

    it 'returns false for a non-world killer_id' do
      expect(valid_kill.world?).to be false
    end
  end

  describe '#suicide?' do
    it 'returns true for a suicide' do
      expect(suicide_kill.suicide?).to be true
    end

    it 'returns false for a non-suicide' do
      expect(valid_kill.suicide?).to be false
    end
  end
end
