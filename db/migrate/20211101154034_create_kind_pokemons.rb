class CreateKindPokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :kind_pokemons do |t|
      t.references :pokemon, null: false, foreign_key: true
      t.references :kind, null: false, foreign_key: true

      t.timestamps
    end
  end
end
