FactoryGirl.define do
  factory :person do
    id Faker::Number.number(3)
    name Faker::Name.name
    tmdb_id Faker::Number.number(4)
  end
end