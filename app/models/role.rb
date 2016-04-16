class Role < ActiveRecord::Base
  validates :person_id, presence: true
  validates :movie_id, presence: true
  validates :job, presence: true, uniqueness: { scope: [:movie_id, :person_id] }
  belongs_to :person
  belongs_to :movie
end
