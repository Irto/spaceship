module Commands
  class PapAuthorize

    include ::Singleton

    include ::Commands::Concerns::Haltable

    def call(session, arguments)
      halt(message: 'Código 0x01350') unless arguments == 'CV-917-ORION-7'

      GameParameter[GameParameter::GENERAL_AUTHORIZATION].update!(value: 'complete')

      halt(status: 'finished', message: 'Código **CV-917-ORION-7** aceito. Bem-vindo, `Copiloto Júnior`. Acesso Nível 2 concedido. Paineis operacionais liberados. Código `0x01300``.')
    end

    def overpass?(parameter)
      true
    end

  end
end
