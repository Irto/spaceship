module Commands

  Command = Struct.new(
    :syntax,
    :name,
    :operation,
    :arguments,
    :description,
    :operation_room,
    :messages,
    :requirements,
    keyword_init: true
  )

  CommandMessages = Struct.new(
    :success,
    :failure,
    :log,
    keyword_init: true
  )

  class Load

    include ::Singleton

    def call
      rooms = [:bridge, :data, :energy, :eng, :tec, :escape]

      commands = rooms.flat_map do |room|
        commands = YAML.load_file(File.expand_path("definitions/#{room}_commands.yml", __dir__))['commands'].map do |command|
          Command.new(
            **command.symbolize_keys,
            messages: CommandMessages.new(**command['messages'].symbolize_keys)
          )
        end
      end

      Commands::COMMANDS_DEFINITIONS.merge!(commands.group_by(&:name))
    end

  end
end
