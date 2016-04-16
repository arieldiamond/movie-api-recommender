FactoryGirl.define do
  factory :movie do
    id Faker::Number.number(3)
    tmdb_id Faker::Number.number(4)
    title Faker::Name.name
    director [Faker::Number.number(4)]
    producer [ Faker::Number.number(4),Faker::Number.number(4) ]
    screenwriter [ Faker::Number.number(4) ]
    genre [ Faker::Number.number(2) ]
    vote_average Faker::Number.decimal(1,2)
    vote_count Faker::Number.number(4)
    popularity Faker::Number.decimal(1,4)
    runtime Faker::Number.number(3)
    release_date "1998-02-15"
    overview "Jeffrey \"The Dude\" Lebowski, a Los Angeles slacker who only wants to bowl and drink white Russians, is mistaken for another Jeffrey Lebowski, a wheelchair-bound millionaire, and finds himself dragged into a strange series of events involving nihilists, adult film producers, ferrets, errant toes, and large sums of money."
    certification "R"
    poster_path "/aHaVjVoXeNanfwUwQ92SG7tosFM.jpg"
  end
end