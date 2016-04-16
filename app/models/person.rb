class Person < ActiveRecord::Base
  validates :name, presence: true
  validates :tmdb_id, presence: true, uniqueness: true
  has_many :roles, foreign_key: :person_id
  has_many :movies, through: :roles
end
