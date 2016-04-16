module API
  module V1
    # People Api Endpoints
    class People < Grape::API
      include API::V1::Defaults
      version 'v1', using: :path

      resource :people do
        desc 'Return List of People'
        params do
          requires :id
        end
        get '/list' do
          @people = PeopleList.new.people_list(params)
        end

        desc 'Return a Person'
        params do
          requires :id, type: String, desc: 'ID of the
            Person'
        end
        get ':id', root: 'person' do
          p params
          if params[:id].to_i != 0
            Person.where('tmdb_id = ?', params[:id].to_i).first!
          else
            title = params[:id].split('+').map(&:capitalize).join(' ')
            Person.where('title = ?', title).first!
          end
        end
      end
    end
  end
end
