class MovieSerializer < ActiveModel::Serializer
  attributes :title, :tmdb_id, :director, :producer, :screenwriter, :actors, :genre, :vote_average, :vote_count, :popularity, :runtime, :release_date, :overview, :certification, :poster_path
end
