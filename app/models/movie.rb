class Movie < ActiveRecord::Base
  validates :tmdb_id, presence: true, uniqueness: true
  validates :title, presence: true

  serialize :genre, Array
  serialize :director, Array
  serialize :producer, Array
  serialize :screenwriter, Array
  serialize :actors, Array

  has_many :roles, foreign_key: :movie_id
  has_many :people, through: :roles

  scope :year_and_genre, -> {
    select(:genre, :release_date, :certification)
  }

  def score_movie(preferences)
    score = [score_genre(preferences[:genres]),
      score_years(preferences[:start_year], preferences[:end_year]),
      score_crew(preferences[:crew]),
      score_cast(preferences[:actors]),
      score_rating(preferences[:cert])
    ]
    score = score.sum + (vote_average * 0.7)
  end

  def score_genre(genres)
    return 0 if genres.blank?
    genres = genres.split(',').flatten
    m_genres = genres.flatten
    g = genres & m_genres
    g.length * 2
  end

  def score_years(start_year, end_year)
    return 0 if start_year.blank? && end_year.blank?
    years = [start_year.to_i, end_year.to_i]
    year = release_date
    m_years = [year - 3, year - 2, year - 1, year, year + 1, year + 2, year + 3]
    y = years & m_years
    y.length * 2
  end

  def score_crew(crew)
    return 0 if crew.blank?
    crew = crew.split(',').flatten
    m_crew = director + producer + screenwriter
    d = crew & m_crew
    d.length * 4
  end

  def score_cast(cast)
    return 0 if actors.blank?
    cast = cast.split(',').flatten
    m_cast = actors

    a = cast & m_cast
    a.length * 5
  end

  def score_rating(rating)
    return 0 if rating.blank? || certification.blank?
    m_rating = certification.split(',')
    r = rating & m_rating
    score = r.length * 2
    if rating.include?('G') && m_rating.include?('R') then score += -10 end
    p score
    score
  end

  def self.insert_movies(movie_list)
    return [] if movie_list.blank?
    movie_list.each do |g|
      @url = 'http://api.themoviedb.org/3/movie/#{g}?api_key=f24e5971a26f6646f8662cb37ea69bc2&append_to_response=release_dates,credits'
      movie = HTTParty.get(@url)
      movie = JSON.parse(movie.body)
      if !movie['title'].nil?
        m = Movie.new(tmdb_id: movie['id'], title: movie['title'], vote_average: movie['vote_average'], vote_count: movie['vote_count'], popularity: movie['popularity'], runtime: movie['runtime'], overview: movie['overview'], poster_path: movie['poster_path'], release_date: movie['release_date'])
        # CREW
        directors = []
        producers = []
        screenwriters = []
        actors = []
        crew = movie['credits']['crew']
        cast = movie['credits']['cast'].first(5)
        crew.each do |c|
          if c['job'] == 'Director'
            directors << c['id']
          elsif c['job'] == 'Executive Producer' || c['job'] == 'Producer'
            producers << c['id']
          elsif c['job'] == 'Writer' || c['job'] == 'Screenplay'
            screenwriters << c['id']
          end
        end
        cast.each do |c|
          actors << c['id']
        end
        m.director = directors
        m.producer = producers
        m.screenwriter = screenwriters
        m.actors = actors
        # CERTIFICATIONS
        movie['release_dates']['results'].each do |c|
          if c['iso_3166_1'] == 'US'
            c['release_dates'].each do |r|
              m.certification = r['certification']
            end
          end
        end
        #  GENRES
        genres = []
        movie['genres'].each do |g|
          genres << [g['id'], g['name']]
        end
        m.genre = genres
        m.save
        # ACTORS
        cast.each do |actor|
          p = Person.find_by(tmdb_id: actor['id'])
          if p.nil? then p = Person.create(name: actor['name'], tmdb_id: actor['id']) end
          Role.create(movie_id: m.id, person_id: p.id, tmdb_id: actor['id'], character: actor['character'], job: 'Actor')
        end
        crew.each do |c|
          if c['job'] == 'Director' || c['job'] == 'Executive Producer' || c['job'] == 'Producer' || c['job'] == 'Writer' || c['job'] == 'Screenplay'
            p = Person.find_by(tmdb_id: c['id'])
            if p.nil? then p = Person.create(name: c['name'], tmdb_id: c['id']) end
            Role.create(movie_id: m.id, person_id: p.id, tmdb_id: c['id'], job: c['job'])
          end
        end
      end
    end
  end
end
