# Movies API endpoints
module API
  module V1
    class Movies < Grape::API
      include API::V1::Defaults
      version 'v1', using: :path

      resource :movies do
        desc 'Return movies baseds on params'
        params do
          optional :genres, type: String
          optional :start_year, type: Integer
          optional :end_year, type: Integer
          optional :certification, type: String
          optional :crew, type: String
          optional :actors, type: String
          optional :movie_id, type: String
        end
        get '/results' do
          @movies = MovieRecommender.new.recommended_movies(params)
        end

        desc 'Return a Movie'
        params do
          requires :id, type: String, desc: 'ID of the Movie'
        end
        get ':id', root: 'movie' do
          p params
          if params[:id].to_i != 0
            Movie.where('tmdb_id = ?', params[:id].to_i).first!
          else
            title = params[:id].split('+').map(&:capitalize).join(' ')
            Movie.where('title = ?', title).first!
          end
        end
      end
    end
  end
end
