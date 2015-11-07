FactoryGirl.define do
  factory :game do
    name 'Super awesome game'
    association :white_player, factory: :user
    association :black_player, factory: :user
  end
end
