# Api Base
module API
  module V1
    class Base < Grape::API
      mount API::V1::Movies
      mount API::V1::People
    end
  end
end
