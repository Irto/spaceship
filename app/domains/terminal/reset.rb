module Terminal
  class Reset

    include ::Singleton

    def call
      Session.delete_all
      GameParameter.delete_all

      GameParameter.create(name: GameParameter::GENERAL_AUTHORIZATION, value: 'incomplete')
      GameParameter.create(name: GameParameter::ENERGY_STABILIZATION, value: 'incomplete')
    end
  end
end
