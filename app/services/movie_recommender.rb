class MovieRecommender
  def recommended_movies(preferences)
    movie_array = api_response(preferences)
    movie_array = check_in_database(movie_array,preferences)
    scored_movies = score_movies(movie_array,preferences).sort_by{|k| -k[:score]}.first(10)
    scored_movies.map {|m| m[:movie] }
  end

  def api_hit(query)
    uri = URI::HTTPS.build(:host => "api.themoviedb.org", :path => "/3/discover/movie", :query => query)
    p uri
    dbmovies = HTTParty.get(uri)
    response = JSON.parse(dbmovies.body)
    response['results']
  end

  def api_response(preferences)
    api_key = {'api_key' => 'f24e5971a26f6646f8662cb37ea69bc2'}.to_query
    if preferences[:movie_id].present?
      preferences = self.selected_movie_preferences(preferences[:movie_id],preferences)
    end
    movie_array = [
      generic_api_hit(preferences,api_key),
      genre_api_hit(preferences,api_key),
      year_api_hit(preferences,api_key),
      crew_api_hit(preferences,api_key),
      actors_api_hit(preferences,api_key)
    ]
    movie_array = movie_array.flatten.uniq
  end

  def generic_api_hit(preferences,api_key)
    return [] if preferences.present?
    query = {'certification_country' => 'US','certification.lte' => 'PG-13'}.to_query + '&' + api_key
    api_hit(query)
  end

  def genre_api_hit(preferences,api_key)
    return [] if preferences[:genres].blank?
    query_g = {'genres' => preferences[:genres] }.to_query + '&' + api_key
    api_hit(query_g)
  end

  def year_api_hit(preferences,api_key)
    return [] if preferences[:start_year].blank? && preferences[:end_year].blank?
    query_e = {'primary_release_year.gte' => preferences[:start_year] ||= '', 'primary_release_year.lte' => preferences[:end_year] ||= '' }.to_query + '&' + api_key
    api_hit(query_e)
  end

  def crew_api_hit(preferences,api_key)
    return [] if preferences[:crew].blank?
    query_d = {'with_people' => preferences[:crew].split(',').join('|')}.to_query + '&' + api_key
    api_hit(query_d)
  end

  def actors_api_hit(preferences,api_key)
    return [] if preferences[:actors].blank?
    query_a = { 'with_people' => preferences[:actors].split(',').join('|') }.to_query + '&' + api_key
    api_hit(query_a)
  end

  def selected_movie_preferences(movies,preferences)
    selected_movies = []
    movies.split(',').each do |m|
      Movie.insert_movies([m]) if Movie.where('tmdb_id = ?', m.to_i).blank?
      movie = Movie.find_by(tmdb_id: m.to_i)
      selected_movies << movie
    end
    year = selected_movies.map(&:release_date).sort
    genres = selected_movies.map{|f| f.genre.map{|g| g[0]}}.flatten
    top_genres = genres.each_with_object(Hash.new(0)) { |genre, counts| counts[genre] += 1 }.sort_by{|k,v| v}.last(3).map{|genre| genre[0]}
    certification = selected_movies.map(&:certification)
    crew = selected_movies.map{|f| f.director+f.producer+f.screenwriter }.flatten.uniq
    actors = selected_movies.map(&:actors).flatten.uniq
    {start_year: year.first, end_year: year.last, genres: top_genres, cert: certification, crew: crew, actors: actors}
  end

  def check_in_database(movies,preferences)
    movies = movies.split(',')
    counter = 1
    movie_objects = []
    movies.each do |list|
      list.each do |m|
        if preferences[:movie_id].present?
          next if preferences[:movie_id].split(',').map{|n| n.to_i}.include? (m['id'])
        end
        if Movie.where("tmdb_id = ?", m['id']).blank?
          Movie.insert_movies([m['id']])
          counter += 1
        end
        if counter > 30 then sleep(0.1) end
        movie_objects << Movie.find_by(tmdb_id: m['id'])
      end
    end
    movie_objects
  end

  def score_movies(movie_array,preferences)
    scores = []
    if preferences[:movie_id].present?
      preferences = self.selected_movie_preferences(preferences[:movie_id],preferences)
    end
    movie_array.each do |m|
      score = 0 if m.blank?
      score = m.score_movie(preferences)
      if score > 10
        scores << {movie: m, score: score}
      end
    end
    scores
  end
end

