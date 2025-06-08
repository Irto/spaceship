module Commands
  class SensorCalibration

    include ::Singleton
    include Rails.application.routes.url_helpers
    include ::Commands::Concerns::Haltable

    def call(session, arguments)
      halt(message: 'Falha! Código 0x150A8') unless arguments.split("\s").first == 'SCG_RESSONANCIA'
      halt(message: 'Falha! Código 0x150A9') unless arguments.split("\s").last == '7.384'

      auth_code = 'MB-H897'

      GameParameter.find_or_create_by(name: ::GameParameter::CALIBRATION_AUTHORIZATION).update(value: auth_code)

      halt(status: 'continue', continue_url: commands_calibration_index_path, message: "Calibragem dos sensores iniciada...")
    end

  end
end
