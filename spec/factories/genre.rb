FactoryGirl.define do
  factory :genre do
    name Faker::Name.name
    genre_id Faker::Number.number(2)
  end
end