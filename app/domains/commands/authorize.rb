module Commands
  class Authorize

    include ::Singleton
    include ::Commands::Concerns::Haltable

    def call(session, arguments)
      if arguments = '15 MB-H897'
        GameParameter[::GameParameter::CALIBRATION_AUTHORIZATION].update(value: 'complete')

        halt(status: 'finished', message: 'Operação MB-H897 da sala tec (15) foi autorizado com sucesso!')
      else
        halt(status: 'error', message: 'Não foi possível encontrar autorização pendentes para o `id_modulo` e `codigo_operacao` informados.')
      end
    end
  end
end
