module Commands
  class ReactorStatus

    include ::Singleton

    include ::Commands::Concerns::Haltable

    def call(session, arguments)
      command = Commands::COMMANDS_DEFINITIONS['reator_principal'].detect { |command| command.syntax == 'reator_principal estado' }

      if ::GameParameter[::GameParameter::ENERGY_STABILIZATION].is?('complete')
        halt(status: 'finished', message: command.messages.success)
      else
        halt(status: 'finished', message: command.messages.failure)
      end
    end
  end
end
