module Commands

  Command = Struct.new(
    :name,
    :operation,
    :arguments,
    :description,
    :success_message,
    :operation_room,
    :log_message,
    :requirements,
    keyword_init: true
  )

  class Load

    include ::Singleton

    def call
      rooms = [:bridge, :data, :energy, :eng, :tec, :escape]

      commands = rooms.flat_map do |room|
        commands = YAML.load_file(File.expand_path("definitions/#{room}_eng.yml", __dir__))['commands'].map do |command|
          Command.new(**command.symbolize_keys)
        end
      end

      Commands::COMMANDS_DEFINITIONS.merge!(commands.group_by(&:name))
    end

  end
end
