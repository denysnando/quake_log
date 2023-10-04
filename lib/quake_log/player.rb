# frozen_string_literal: true

class Player
  attr_accessor :id, :nickname

  def initialize(id:, nickname:)
    @id = id
    @nickname = nickname
  end
end
