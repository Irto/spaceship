Rails.application.config.after_initialize do
  ::Commands::Load.instance.call

  if defined? ActiveSupport::Reloader
    ActiveSupport::Reloader.to_prepare { ::Commands::Load.instance.call }
  else
    ActionDispatch::Reloader.to_prepare { ::Commands::Load.instance.call }
  end
end
