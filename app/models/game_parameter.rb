class GameParameter < ::ApplicationRecord
  GENERAL_AUTHORIZATION = 'general_authorization'
  ENERGY_STABILIZATION = 'energy_stabilization'

  def self.[](name)
    find_by(name: name)
  end

  def is?(value)
    self.value == value.to_s
  end
end
