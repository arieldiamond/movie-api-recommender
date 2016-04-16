class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.integer :tmdb_id
      t.string :title
      t.string :director
      t.string :producer
      t.string :screenwriter
      t.string :actors
      t.string :genre
      t.float :vote_average
      t.integer :vote_count
      t.float :popularity
      t.integer :runtime
      t.integer :release_date
      t.string :overview
      t.string :certification
      t.string :poster_path

      t.timestamps null: false
    end
  end
end
