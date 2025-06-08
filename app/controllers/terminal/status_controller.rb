module Terminal
  class StatusController < ::ActionController::API

    def index
      minimum_session_created_at = Session.minimum(:created_at)
      ::Terminal::Reset.instance.call if minimum_session_created_at.present? && minimum_session_created_at < 5.minutes.ago

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
