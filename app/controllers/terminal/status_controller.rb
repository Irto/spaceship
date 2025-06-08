module Terminal
  class StatusController < ::ActionController::API

    def index
      terminal = ::Session.find_or_create_by(name: params[:name])

      render(json: {
        terminal: {
          id: terminal.id,
          name: terminal.name,
        }
      }, status: :ok)
    end
  end
end
