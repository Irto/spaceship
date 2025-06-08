module Commands
  class Execute

    include ::Singleton
    include ::Commands::Concerns::Haltable

    ExecutionResult = Struct.new(:status, :message, :continue_url, keyword_init: true)

    class CommandInvalid < StandardError; end

    COMMANDS_WITH_BEHAVIOUR = {
      'pap autenticar' => ::Commands::PapAuthorize.instance,
      'calibrar_sensores modular_frequencia_harmonica' => ::Commands::SensorCalibration.instance,
      'reator_principal estado' => ::Commands::ReactorStatus.instance,
      'ponte autorizar' => ::Commands::Authorize.instance,
      'nuclear calibrar_hastes' => ::Commands::RodsCalibration.instance,
    }

    def call(session, name, operation, arguments)
      catch(:result) do
        halt(status: 'error', message: "Comando inexistente, não foi possível encontrar \"`#{name}`\" no sistema.#{available_commands_message(session)}") if Commands::COMMANDS_DEFINITIONS[name].blank?

        command = Commands::COMMANDS_DEFINITIONS[name].detect { |command| command.operation == operation }

        halt(status: 'error', message: "Operação inexistente, não foi possível encontrar operação \"`#{operation}`\" no comando \"`#{name}`\".") if command.blank?

        halt(status: 'error', message: "**Comando não autorizado!** Esse terminal (#{session.name}) não possui os níveis de permissão necessários para execução de comandos \"`#{name}`\".") if command.operation_room != session.name

        behaviour = COMMANDS_WITH_BEHAVIOUR["#{name} #{operation}"]

        meet_requirements!(command.requirements)

        behaviour&.call(session, arguments)

        ExecutionResult.new(status: 'finished', message: command.messages.success)
      end
    end

    private

    def available_commands_message(session)
      <<~MESSAGE
        \n\n**Commandos disponíveis:** `#{Commands::COMMANDS_DEFINITIONS.values.flatten.select { |command| command.operation_room == session.name }.map(&:name).uniq.join(', ')}`\n
      MESSAGE
    end

    def meet_requirements!(requirements)
      requirements.each do |requirement|
        halt_error_for(requirement) unless GameParameter[requirement].is?('complete')
      end
    end

    def halt_error_for(requirement)
      case(requirement)
      when GameParameter::GENERAL_AUTHORIZATION then halt(status: 'error', message: "SISTEMA BLOQUEADO, OPERADOR NECESSÁRIO")
      when GameParameter::ENERGY_STABILIZATION then halt(status: 'error', message: "Impossível executar comando, sistema funcionando em nível crítico. (FALHA CRÍTICA: Flutuação de energia induzida por ressonância gravitacional externa (Ref: Alerta Engenharia ARG-05-01). Compensação da Engenharia (05) ineficaz. Reator Principal operando em código 0x01020).")
      end
    end

  end
end
