module Commands
  class RodsCalibration

    include ::Singleton
    include ::Commands::Concerns::Haltable

    def call(session, arguments)
      halt(status: 'finished', message: 'Não há calibrações pendentes, nada foi executado.') unless GameParameter[::GameParameter::CALIBRATION_AUTHORIZATION]&.is?('complete')

      GameParameter[::GameParameter::REACTOR_RODS_CALIBRATION].update(value: 'complete')

      halt(status: 'finished', message: 'Calibração das hastes de controle concluída. Precisão dentro de 0.01mm.')
    end

  end
end
