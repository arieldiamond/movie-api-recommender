class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :movie_id
      t.integer :person_id
      t.integer :tmdb_id
      t.string :character
      t.string :job

      t.timestamps null: false
    end
  end
end
