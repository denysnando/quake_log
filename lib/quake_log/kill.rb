# frozen_string_literal: true

class Kill
  KILLER_WORLD_ID = 1022

  attr_reader :killer_id, :victim_id, :death_type

  def initialize(killer_id:, victim_id:, death_type:)
    validate_input(killer_id, victim_id, death_type)
    @killer_id = killer_id
    @victim_id = victim_id
    @death_type = death_type
  end

  def world?
    killer_id == KILLER_WORLD_ID
  end

  def suicide?
    killer_id == victim_id
  end

  private

  def validate_input(killer_id, victim_id, death_type)
    validate_integer_positive(killer_id, 'Killer ID')
    validate_integer_positive(victim_id, 'Victim ID')
    validate_non_empty_string(death_type, 'Death type')
  end

  def validate_integer_positive(value, field)
    raise ArgumentError, "#{field} must be a positive integer" unless value.is_a?(Integer) && value.positive?
  end

  def validate_non_empty_string(value, field)
    raise ArgumentError, "#{field} must be a non-empty string" unless value.is_a?(String) && !value.empty?
  end
end
