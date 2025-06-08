module Commands
  module Concerns
    module Haltable
      def halt(**data)
        throw :result, ::Commands::Execute::ExecutionResult.new(data)
      end
    end
  end
end
