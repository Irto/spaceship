module Commands
  class ExecutionsController < ::ActionController::API

    def create
      execution = params.require(:execution).permit(:name, :operation, :terminal_id)

      session = Session.find(execution[:terminal_id])
      operation, arguments = execution[:operation].presence.to_s.split("\s", 2)

      execution_result = ::Commands::Execute.instance.call(session, execution[:name], operation, arguments)

      render(json: {
        status: execution_result.status,
        message: markdown.render(execution_result.message)
      }, status: :ok)
    end

    private

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end
  end
end
