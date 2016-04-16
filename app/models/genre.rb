class Genre < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :genre_id, presence: true, uniqueness: true
end

