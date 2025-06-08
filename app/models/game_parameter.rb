class GameParameter < ::ApplicationRecord
  GENERAL_AUTHORIZATION = 'general_authorization'
  ENERGY_STABILIZATION = 'energy_stabilization'
  CALIBRATION_AUTHORIZATION = 'calibration_authorization'
  REACTOR_RODS_CALIBRATION = 'reactor_rods_calibration'

  def self.[](name)
    find_by(name: name)
  end

  def is?(value)
    self.value == value.to_s
  end
end
