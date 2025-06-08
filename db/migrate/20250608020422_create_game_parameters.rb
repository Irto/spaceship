class CreateGameParameters < ActiveRecord::Migration[7.1]
  def change
    create_table :game_parameters do |t|
      t.string :name
      t.string :value

      t.timestamps

      t.index :name, unique: true
    end
  end
end
