# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Player do
  let(:player) { described_class.new(id: 1, nickname: 'Isgalamido') }

  describe '#initialize' do
    it 'sets the id correctly' do
      expect(player.instance_variable_get(:@id)).to eq(1)
    end

    it 'sets the nickname correctly' do
      expect(player.instance_variable_get(:@nickname)).to eq('Isgalamido')
    end
  end
end
